Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3LQAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:48:20 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:43450 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3LQAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:48:18 -0500
Date: Mon, 16 Dec 2013 17:48:15 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pci: Add Virtual Channel to save/restore support
Message-ID: <20131217004815.GA4781@google.com>
References: <20131210183339.26294.14581.stgit@bling.home>
 <20131210184845.26294.81385.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210184845.26294.81385.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:48:45AM -0700, Alex Williamson wrote:
> While we don't really have any infrastructure for making use of VC
> support, the system BIOS can configure the topology to non-default
> VC values prior to boot.  This may be due to silicon bugs, desire to
> reserve traffic classes, or perhaps just BIOS bugs.  When we reset
> devices, the VC configuration may return to default values, which can
> be incompatible with devices upstream.  For instance, Nvidia GRID
> cards provide a PCIe switch and some number of GPUs, all supporting
> VC.  The power-on default for VC is to support TC0-7 across VC0,
> however some platforms will only enable TC0/VC0 mapping across the
> topology.  When we do a secondary bus reset on the downstream switch
> port, the GPU is reset to a TC0-7/VC0 mapping while the opposite end
> of the link only enables TC0/VC0.  If the GPU attempts to use TC1-7,
> it fails.
> 
> This patch attempts to provide complete support for VC save/restore,
> even beyond the minimally required use case above.  This includes
> save/restore and reload of the arbitration table, save/restore and
> reload of the port arbitration tables, and re-enabling of the
> channels for VC, VC9, and MFVC capabilities.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/pci.c |  387 +++++++++++++++++++++++++++++++++++++++++++++++++++++

Wow, that's a lot of code just to support resetting a device.  I wish I had
a better idea, but I don't.  I know we have similar save/restore code in
pci.c already, but would it make sense to put this in a vc.c to keep pci.c
from growing without bound?

>  1 file changed, 387 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a898e4e..3a1d060 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -969,6 +969,367 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>  	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
>  }
>  
> +/**
> + * pci_vc_save_restore_dwords - Save or restore a series of dwords
> + * @dev: device
> + * @pos: starting config space position
> + * @buf: buffer to save to or restore from
> + * @dwords: number of dwords to save/restore
> + * @save: whether to save or restore
> + */
> +static void pci_vc_save_restore_dwords(struct pci_dev *dev, int pos,
> +				       u32 *buf, int dwords, bool save)

Nothing VC-specific here, so maybe remove "_vc_" from the name.

> +{
> +	int i;
> +
> +	for (i = 0; i < dwords; i++, buf++) {
> +		if (save)
> +			pci_read_config_dword(dev, pos + (i * 4), buf);
> +		else
> +			pci_write_config_dword(dev, pos + (i * 4), *buf);
> +	}
> +}
> +
> +/**
> + * pci_vc_load_port_arb_table - load and wait for VC arbitration table
> + * @dev: device
> + * @pos: starting position of VC capability (VC/VC9/MFVC)
> + *
> + * Signal a VC arbitration table to load and wait for completion.
> + */
> +static void pci_vc_load_arb_table(struct pci_dev *dev, int pos)
> +{
> +	u32 ctrl;
> +
> +	pci_read_config_dword(dev, pos + PCI_VC_PORT_CTRL, &ctrl);
> +	pci_write_config_dword(dev, pos + PCI_VC_PORT_CTRL, ctrl | 1);
> +	if (pci_wait_for_pending(dev, pos + PCI_VC_PORT_STATUS, 1))

Comment doesn't match function name.  The spec "Request hardware to apply
new values" language would be a useful clue that this doesn't actually
*write* the table; before reading the spec, I initially looked for a
buffer containing the arbitration table.  It'd be nice to have #defines
for the bits here, i.e., PCI_VC_PORT_CTRL_LOAD_ARB or similar.  The
spec says these are 16-bit registers; shouldn't these be "word" accesses?

> +		return;
> +
> +	dev_err(&dev->dev, "VC arbitration table failed to load\n");
> +}
> +
> +/**
> + * pci_vc_load_port_arb_table - Load and wait for VC port arbitration table
> + * @dev: device
> + * @pos: starting position of VC capability (VC/VC9/MFVC)
> + * @res: VC res number, ie. VCn (0-7)
> + *
> + * Signal a VC port arbitration table to load and wait for completion.
> + */
> +static void pci_vc_load_port_arb_table(struct pci_dev *dev, int pos, int res)
> +{
> +	int ctrl_pos, status_pos;
> +	u32 ctrl;
> +
> +	ctrl_pos = pos + PCI_VC_RES_CTRL + (res * PCI_CAP_VC_PER_VC_SIZEOF);
> +	status_pos = pos + PCI_VC_RES_STATUS + (res * PCI_CAP_VC_PER_VC_SIZEOF);
> +
> +	pci_read_config_dword(dev, ctrl_pos, &ctrl);
> +	pci_write_config_dword(dev, ctrl_pos, ctrl | (1 << 16));
> +
> +	if (pci_wait_for_pending(dev, status_pos, 1))

#defines, please, to help grep users later.

> +		return;
> +
> +	dev_err(&dev->dev, "VC%d port arbitration table failed to load\n", res);
> +}
> +
> +/**
> + * pci_vc_enable - Enable virtual channel
> + * @dev: device
> + * @pos: starting position of VC capability (VC/VC9/MFVC)
> + * @res: VC res number, ie. VCn (0-7)
> + *
> + * A VC is enabled by setting the enable bit in matching resource control
> + * registers on both sides of a link.  We therefore need to find the opposite
> + * end of the link.  To keep this simple we enable from the downstream device.
> + * RC devices do not have an upstream device, nor does it seem that VC9 do
> + * (spec is unclear).  Once we find the upstream device, match the VC ID to
> + * get the correct resource, disable and enable on both ends.
> + */
> +static void pci_vc_enable(struct pci_dev *dev, int pos, int res)
> +{
> +	int ctrl_pos, status_pos, id, pos2, evcc, i, ctrl_pos2, status_pos2;
> +	u32 ctrl, header, reg1, ctrl2;
> +	struct pci_dev *link = NULL;
> +
> +	/* Enable VCs from the downstream device */
> +	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
> +	    pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM)
> +		return;
> +
> +	ctrl_pos = pos + PCI_VC_RES_CTRL + (res * PCI_CAP_VC_PER_VC_SIZEOF);
> +	status_pos = pos + PCI_VC_RES_STATUS + (res * PCI_CAP_VC_PER_VC_SIZEOF);
> +
> +	pci_read_config_dword(dev, ctrl_pos, &ctrl);
> +	id = (ctrl >> 24) & 0x7;

#define PCI_VC_RES_CTRL_ID 0x07000000.

It gets a little cumbersome to have #defines for *both* the mask and the
shift; the compromise I like is to have a #define for the mask (which shows
the position in the register) and use bare numbers when we need to shift.
Then it's easy to find uses of the field with grep or cscope, and the mask
definition helps manual decoding.  There are several other opportunities
for mask #defines below.

In this case, you only compare ID values, so there's actually no need to
shift it.

> +
> +	pci_read_config_dword(dev, pos, &header);
> +
> +	/* If there is no opposite end of the link, skip to enable */
> +	if (PCI_EXT_CAP_ID(header) == PCI_EXT_CAP_ID_VC9 ||
> +	    pci_is_root_bus(dev->bus))
> +		goto enable;
> +
> +	pos2 = pci_find_ext_capability(dev->bus->self, PCI_EXT_CAP_ID_VC);
> +	if (pos2 <= 0)
> +		goto enable;

I don't think < 0 is possible (several other occurrences below, too).

> +
> +	pci_read_config_dword(dev->bus->self, pos2 + PCI_VC_PORT_REG1, &reg1);
> +	evcc = reg1 & PCI_VC_REG1_EVCC;
> +
> +	/* VC0 is hardwired enabled, so we can start with 1 */
> +	for (i = 1; i < evcc + 1; i++) {
> +		ctrl_pos2 = pos2 + PCI_VC_RES_CTRL +
> +				(i * PCI_CAP_VC_PER_VC_SIZEOF);
> +		status_pos2 = pos2 + PCI_VC_RES_STATUS +
> +				(i * PCI_CAP_VC_PER_VC_SIZEOF);
> +		pci_read_config_dword(dev->bus->self, ctrl_pos2, &ctrl2);
> +		if (((ctrl2 >> 24) & 0x7) == id) {
> +			link = dev->bus->self;
> +			break;
> +		}
> +	}
> +
> +	if (!link)
> +		goto enable;
> +
> +	/* Disable if enabled */
> +	if (ctrl2 & (1U << 31)) {
> +		ctrl2 &= ~(1U << 31);
> +		pci_write_config_dword(link, ctrl_pos2, ctrl2);
> +	}
> +
> +	/* Enable on both ends */
> +	ctrl2 |= 1U << 31;
> +	pci_write_config_dword(link, ctrl_pos2, ctrl2);
> +enable:
> +	ctrl |= 1U << 31;
> +	pci_write_config_dword(dev, ctrl_pos, ctrl);
> +
> +	if (!pci_wait_for_pending(dev, status_pos, 0x2))
> +		dev_err(&dev->dev, "VC%d negotiation stuck pending\n", id);
> +
> +	if (link && !pci_wait_for_pending(link, status_pos2, 0x2))
> +		dev_err(&link->dev, "VC%d negotiation stuck pending\n", id);
> +}
> +
> +/**
> + * pci_vc_do_save_buffer - Size, save, or restore VC state
> + * @dev: device
> + * @pos: starting position of VC capability (VC/VC9/MFVC)
> + * @save_state: buffer for save/restore
> + * @name: for error message
> + * @save: if provided a buffer, this indicates what to do with it
> + *
> + * Walking Virtual Channel config space to size, save, or restore it
> + * is complicated, so we do it all from one function to reduce code and
> + * guarantee ordering matches in the buffer.  When called with NULL
> + * @save_state, return the size of the necessary save buffer.  When called
> + * with a non-NULL @save_state, @save determines whether we save to the
> + * buffer or restore from it.
> + */
> +static int pci_vc_do_save_buffer(struct pci_dev *dev, int pos,
> +				 struct pci_cap_saved_state *save_state,
> +				 bool save)
> +{
> +	u32 reg1;
> +	char evcc, lpevcc, parb_size;
> +	int i, len = 0;
> +	u32 *buf = save_state ? save_state->cap.data : NULL;
> +
> +	/* Sanity check buffer size for save/restore */
> +	if (buf && save_state->cap.size !=
> +	    pci_vc_do_save_buffer(dev, pos, NULL, save)) {
> +		dev_err(&dev->dev,
> +			"VC save buffer size does not match @0x%x\n", pos);
> +		return -ENOMEM;
> +	}
> +
> +	pci_read_config_dword(dev, pos + PCI_VC_PORT_REG1, &reg1);
> +	/* Extended VC Count (not counting VC0) */
> +	evcc = reg1 & PCI_VC_REG1_EVCC;
> +	/* Low Priority Extended VC Count (not counting VC0) */
> +	lpevcc = (reg1 >> 4) & PCI_VC_REG1_EVCC;

Please make a new #define, since LPEVCC is a separate field.

> +	/* Port Arbitration Table Entry Size (bits) */
> +	parb_size = 1 << ((reg1 >> 10) & 0x3);
> +
> +	/*
> +	 * Port VC Control Register contains VC Arbitration Select, which
> +	 * cannot be modified when more than one LPVC is in operation.  We
> +	 * therefore save/restore it first, as only VC0 should be enabled
> +	 * after device reset.
> +	 */
> +	if (buf) {
> +		pci_vc_save_restore_dwords(dev, pos + PCI_VC_PORT_CTRL,
> +					   buf, 1, save);
> +		buf++;
> +	}
> +	len += 4;
> +
> +	/*
> +	 * If we have any Low Priority VCs and a VC Arbitration Table Offset
> +	 * in Port VC Capability Register 2 then save/restore it next.
> +	 */
> +	if (lpevcc) {
> +		u32 reg2;
> +		int vcarb_offset;
> +
> +		pci_read_config_dword(dev, pos + PCI_VC_PORT_REG2, &reg2);
> +		vcarb_offset = (reg2 >> 24) * 16;
> +
> +		if (vcarb_offset) {
> +			int size, vcarb_phases = 0;
> +
> +			if (reg2 & PCI_VC_REG2_128_PHASE)
> +				vcarb_phases = 128;
> +			else if (reg2 & PCI_VC_REG2_64_PHASE)
> +				vcarb_phases = 64;
> +			else if (reg2 & PCI_VC_REG2_32_PHASE)
> +				vcarb_phases = 32;
> +
> +			/* Fixed 4 bits per phase per lpevcc (plus VC0) */
> +			size = ((lpevcc + 1) * vcarb_phases * 4) / 8;
> +
> +			if (size && buf) {
> +				pci_vc_save_restore_dwords(dev,
> +							   pos + vcarb_offset,
> +							   buf, size / 4, save);
> +				/*
> +				 * On restore, we need to signal hardware to
> +				 * re-load the VC Arbitration Table.
> +				 */
> +				if (!save)
> +					pci_vc_load_arb_table(dev, pos);
> +
> +				buf += size / 4;
> +			}
> +			len += size;
> +		}
> +	}
> +
> +	/*
> +	 * In addition to each VC Resource Control Register, we may have a
> +	 * Port Arbitration Table attached to each VC.  The Port Arbitration
> +	 * Table Offset in each VC Resource Capability Register tells us if
> +	 * it exists.  The entry size is global from the Port VC Capability
> +	 * Register1 above.  The number of phases is determined per VC.
> +	 */
> +	for (i = 0; i < evcc + 1; i++) {
> +		u32 cap;
> +		int parb_offset;
> +
> +		pci_read_config_dword(dev, pos + PCI_VC_RES_CAP +
> +				      (i * PCI_CAP_VC_PER_VC_SIZEOF), &cap);
> +		parb_offset = (cap >> 24) * 16;
> +		if (parb_offset) {
> +			int size, parb_phases = 0;
> +
> +			if (cap & 0x20)
> +				parb_phases = 256;
> +			else if (cap & 0x18)
> +				parb_phases = 128;
> +			else if (cap & 0x4)
> +				parb_phases = 64;
> +			else if (cap & 0x2)
> +				parb_phases = 32;
> +
> +			size = (parb_size * parb_phases) / 8;
> +
> +			if (size && buf) {
> +				pci_vc_save_restore_dwords(dev,
> +							   pos + parb_offset,
> +							   buf, size / 4, save);
> +				buf += size / 4;
> +			}
> +			len += size;
> +		}
> +
> +		/* VC Resource Control Register */
> +		if (buf) {
> +			int ctrl_pos = pos + PCI_VC_RES_CTRL +
> +						(i * PCI_CAP_VC_PER_VC_SIZEOF);
> +			if (save)
> +				pci_read_config_dword(dev, ctrl_pos, buf);
> +			else {
> +				u32 tmp, ctrl = *(u32 *)buf;
> +				/*
> +				 * For an FLR case, the VC config may remain.
> +				 * Preserve enable bit, restore the rest.
> +				 */
> +				pci_read_config_dword(dev, ctrl_pos, &tmp);
> +				tmp &= 1U << 31;
> +				tmp |= ctrl & ~(1U << 31);
> +				pci_write_config_dword(dev, ctrl_pos, tmp);
> +				/* Load port arbitration table if used */
> +				if (ctrl & (7 << 17))
> +					pci_vc_load_port_arb_table(dev, pos, i);
> +				/* Re-enable if needed */
> +				if ((ctrl ^ tmp) & (1U << 31))
> +					pci_vc_enable(dev, pos, i);
> +			}
> +			buf++;
> +		}
> +		len += 4;
> +	}
> +
> +	return buf ? 0 : len;
> +}
> +
> +static struct {
> +	u16 id;
> +	const char *name;
> +} vc_caps[] = { { PCI_EXT_CAP_ID_MFVC, "MFVC" },
> +		{ PCI_EXT_CAP_ID_VC, "VC" },
> +		{ PCI_EXT_CAP_ID_VC9, "VC9" } };
> +
> +static int pci_save_vc_state(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
> +		int pos, ret;
> +		struct pci_cap_saved_state *save_state;
> +
> +		pos = pci_find_ext_capability(dev, vc_caps[i].id);
> +		if (pos <= 0)
> +			continue;
> +
> +		save_state = pci_find_saved_ext_cap(dev, vc_caps[i].id);
> +		if (!save_state) {
> +			dev_err(&dev->dev, "%s buffer not found in %s\n",
> +				vc_caps[i].name, __func__);
> +			return -ENOMEM;
> +		}
> +
> +		ret = pci_vc_do_save_buffer(dev, pos, save_state, true);
> +		if (ret) {
> +			dev_err(&dev->dev, "%s save unsuccessful %s\n",
> +				vc_caps[i].name, __func__);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void pci_restore_vc_state(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
> +		int pos;
> +		struct pci_cap_saved_state *save_state;
> +
> +		pos = pci_find_ext_capability(dev, vc_caps[i].id);
> +		save_state = pci_find_saved_ext_cap(dev, vc_caps[i].id);
> +		if (!save_state || pos <= 0)
> +			continue;
> +
> +		pci_vc_do_save_buffer(dev, pos, save_state, false);
> +	}
> +}
> +
>  
>  /**
>   * pci_save_state - save the PCI configuration space of a device before suspending
> @@ -986,6 +1347,8 @@ pci_save_state(struct pci_dev *dev)
>  		return i;
>  	if ((i = pci_save_pcix_state(dev)) != 0)
>  		return i;
> +	if ((i = pci_save_vc_state(dev)) != 0)
> +		return i;
>  	return 0;
>  }
>  
> @@ -1048,6 +1411,7 @@ void pci_restore_state(struct pci_dev *dev)
>  	/* PCI Express register must be restored first */
>  	pci_restore_pcie_state(dev);
>  	pci_restore_ats_state(dev);
> +	pci_restore_vc_state(dev);
>  
>  	pci_restore_config_space(dev);
>  
> @@ -2104,6 +2468,27 @@ static int pci_add_ext_cap_save_buffer(struct pci_dev *dev,
>  	return _pci_add_cap_save_buffer(dev, cap, true, size);
>  }
>  
> +static void pci_allocate_vc_save_buffers(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
> +		int error, pos = pci_find_ext_capability(dev, vc_caps[i].id);
> +		int len;
> +
> +		if (pos <= 0)
> +			continue;
> +
> +		len = pci_vc_do_save_buffer(dev, pos, NULL, false);
> +		error = pci_add_ext_cap_save_buffer(dev,
> +						    vc_caps[i].id, len);
> +		if (error)
> +			dev_err(&dev->dev,
> +				"unable to preallocate %s save buffer\n",
> +				vc_caps[i].name);
> +	}
> +}
> +
>  /**
>   * pci_allocate_cap_save_buffers - allocate buffers for saving capabilities
>   * @dev: the PCI device
> @@ -2122,6 +2507,8 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
>  	if (error)
>  		dev_err(&dev->dev,
>  			"unable to preallocate PCI-X save buffer\n");
> +
> +	pci_allocate_vc_save_buffers(dev);
>  }
>  
>  void pci_free_cap_save_buffers(struct pci_dev *dev)
> 

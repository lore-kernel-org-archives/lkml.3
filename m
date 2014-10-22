Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaJVI3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:29:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44133 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaJVI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:29:20 -0400
Date: Wed, 22 Oct 2014 01:29:16 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
Message-ID: <20141022082916.GD16128@brian-ubuntu>
References: <20140929124246.3e39dac8@gandalf.local.home>
 <cover.1412031505.git.joe@perches.com>
 <c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 04:08:27PM -0700, Joe Perches wrote:
> seq_printf doesn't return a useful value, so remove
> these misuses.

Good catch. So it looks like this driver always had some form of
wrongness (returning a character count) in its debugfs callbacks, but
nobody noticed.

Applied to l2-mtd.git. Thanks!

Brian

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mtd/devices/docg3.c | 112 ++++++++++++++++++++------------------------
>  1 file changed, 52 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
> index 21cc4b6..68ff83c 100644
> --- a/drivers/mtd/devices/docg3.c
> +++ b/drivers/mtd/devices/docg3.c
> @@ -1655,22 +1655,21 @@ static int dbg_flashctrl_show(struct seq_file *s, void *p)
>  {
>  	struct docg3 *docg3 = (struct docg3 *)s->private;
>  
> -	int pos = 0;
>  	u8 fctrl;
>  
>  	mutex_lock(&docg3->cascade->lock);
>  	fctrl = doc_register_readb(docg3, DOC_FLASHCONTROL);
>  	mutex_unlock(&docg3->cascade->lock);
>  
> -	pos += seq_printf(s,
> -		 "FlashControl : 0x%02x (%s,CE# %s,%s,%s,flash %s)\n",
> -		 fctrl,
> -		 fctrl & DOC_CTRL_VIOLATION ? "protocol violation" : "-",
> -		 fctrl & DOC_CTRL_CE ? "active" : "inactive",
> -		 fctrl & DOC_CTRL_PROTECTION_ERROR ? "protection error" : "-",
> -		 fctrl & DOC_CTRL_SEQUENCE_ERROR ? "sequence error" : "-",
> -		 fctrl & DOC_CTRL_FLASHREADY ? "ready" : "not ready");
> -	return pos;
> +	seq_printf(s, "FlashControl : 0x%02x (%s,CE# %s,%s,%s,flash %s)\n",
> +		   fctrl,
> +		   fctrl & DOC_CTRL_VIOLATION ? "protocol violation" : "-",
> +		   fctrl & DOC_CTRL_CE ? "active" : "inactive",
> +		   fctrl & DOC_CTRL_PROTECTION_ERROR ? "protection error" : "-",
> +		   fctrl & DOC_CTRL_SEQUENCE_ERROR ? "sequence error" : "-",
> +		   fctrl & DOC_CTRL_FLASHREADY ? "ready" : "not ready");
> +
> +	return 0;
>  }
>  DEBUGFS_RO_ATTR(flashcontrol, dbg_flashctrl_show);
>  
> @@ -1678,58 +1677,56 @@ static int dbg_asicmode_show(struct seq_file *s, void *p)
>  {
>  	struct docg3 *docg3 = (struct docg3 *)s->private;
>  
> -	int pos = 0, pctrl, mode;
> +	int pctrl, mode;
>  
>  	mutex_lock(&docg3->cascade->lock);
>  	pctrl = doc_register_readb(docg3, DOC_ASICMODE);
>  	mode = pctrl & 0x03;
>  	mutex_unlock(&docg3->cascade->lock);
>  
> -	pos += seq_printf(s,
> -			 "%04x : RAM_WE=%d,RSTIN_RESET=%d,BDETCT_RESET=%d,WRITE_ENABLE=%d,POWERDOWN=%d,MODE=%d%d (",
> -			 pctrl,
> -			 pctrl & DOC_ASICMODE_RAM_WE ? 1 : 0,
> -			 pctrl & DOC_ASICMODE_RSTIN_RESET ? 1 : 0,
> -			 pctrl & DOC_ASICMODE_BDETCT_RESET ? 1 : 0,
> -			 pctrl & DOC_ASICMODE_MDWREN ? 1 : 0,
> -			 pctrl & DOC_ASICMODE_POWERDOWN ? 1 : 0,
> -			 mode >> 1, mode & 0x1);
> +	seq_printf(s,
> +		   "%04x : RAM_WE=%d,RSTIN_RESET=%d,BDETCT_RESET=%d,WRITE_ENABLE=%d,POWERDOWN=%d,MODE=%d%d (",
> +		   pctrl,
> +		   pctrl & DOC_ASICMODE_RAM_WE ? 1 : 0,
> +		   pctrl & DOC_ASICMODE_RSTIN_RESET ? 1 : 0,
> +		   pctrl & DOC_ASICMODE_BDETCT_RESET ? 1 : 0,
> +		   pctrl & DOC_ASICMODE_MDWREN ? 1 : 0,
> +		   pctrl & DOC_ASICMODE_POWERDOWN ? 1 : 0,
> +		   mode >> 1, mode & 0x1);
>  
>  	switch (mode) {
>  	case DOC_ASICMODE_RESET:
> -		pos += seq_puts(s, "reset");
> +		seq_puts(s, "reset");
>  		break;
>  	case DOC_ASICMODE_NORMAL:
> -		pos += seq_puts(s, "normal");
> +		seq_puts(s, "normal");
>  		break;
>  	case DOC_ASICMODE_POWERDOWN:
> -		pos += seq_puts(s, "powerdown");
> +		seq_puts(s, "powerdown");
>  		break;
>  	}
> -	pos += seq_puts(s, ")\n");
> -	return pos;
> +	seq_puts(s, ")\n");
> +	return 0;
>  }
>  DEBUGFS_RO_ATTR(asic_mode, dbg_asicmode_show);
>  
>  static int dbg_device_id_show(struct seq_file *s, void *p)
>  {
>  	struct docg3 *docg3 = (struct docg3 *)s->private;
> -	int pos = 0;
>  	int id;
>  
>  	mutex_lock(&docg3->cascade->lock);
>  	id = doc_register_readb(docg3, DOC_DEVICESELECT);
>  	mutex_unlock(&docg3->cascade->lock);
>  
> -	pos += seq_printf(s, "DeviceId = %d\n", id);
> -	return pos;
> +	seq_printf(s, "DeviceId = %d\n", id);
> +	return 0;
>  }
>  DEBUGFS_RO_ATTR(device_id, dbg_device_id_show);
>  
>  static int dbg_protection_show(struct seq_file *s, void *p)
>  {
>  	struct docg3 *docg3 = (struct docg3 *)s->private;
> -	int pos = 0;
>  	int protect, dps0, dps0_low, dps0_high, dps1, dps1_low, dps1_high;
>  
>  	mutex_lock(&docg3->cascade->lock);
> @@ -1742,45 +1739,40 @@ static int dbg_protection_show(struct seq_file *s, void *p)
>  	dps1_high = doc_register_readw(docg3, DOC_DPS1_ADDRHIGH);
>  	mutex_unlock(&docg3->cascade->lock);
>  
> -	pos += seq_printf(s, "Protection = 0x%02x (",
> -			 protect);
> +	seq_printf(s, "Protection = 0x%02x (", protect);
>  	if (protect & DOC_PROTECT_FOUNDRY_OTP_LOCK)
> -		pos += seq_puts(s, "FOUNDRY_OTP_LOCK,");
> +		seq_puts(s, "FOUNDRY_OTP_LOCK,");
>  	if (protect & DOC_PROTECT_CUSTOMER_OTP_LOCK)
> -		pos += seq_puts(s, "CUSTOMER_OTP_LOCK,");
> +		seq_puts(s, "CUSTOMER_OTP_LOCK,");
>  	if (protect & DOC_PROTECT_LOCK_INPUT)
> -		pos += seq_puts(s, "LOCK_INPUT,");
> +		seq_puts(s, "LOCK_INPUT,");
>  	if (protect & DOC_PROTECT_STICKY_LOCK)
> -		pos += seq_puts(s, "STICKY_LOCK,");
> +		seq_puts(s, "STICKY_LOCK,");
>  	if (protect & DOC_PROTECT_PROTECTION_ENABLED)
> -		pos += seq_puts(s, "PROTECTION ON,");
> +		seq_puts(s, "PROTECTION ON,");
>  	if (protect & DOC_PROTECT_IPL_DOWNLOAD_LOCK)
> -		pos += seq_puts(s, "IPL_DOWNLOAD_LOCK,");
> +		seq_puts(s, "IPL_DOWNLOAD_LOCK,");
>  	if (protect & DOC_PROTECT_PROTECTION_ERROR)
> -		pos += seq_puts(s, "PROTECT_ERR,");
> +		seq_puts(s, "PROTECT_ERR,");
>  	else
> -		pos += seq_puts(s, "NO_PROTECT_ERR");
> -	pos += seq_puts(s, ")\n");
> -
> -	pos += seq_printf(s, "DPS0 = 0x%02x : "
> -			 "Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, "
> -			 "WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
> -			 dps0, dps0_low, dps0_high,
> -			 !!(dps0 & DOC_DPS_OTP_PROTECTED),
> -			 !!(dps0 & DOC_DPS_READ_PROTECTED),
> -			 !!(dps0 & DOC_DPS_WRITE_PROTECTED),
> -			 !!(dps0 & DOC_DPS_HW_LOCK_ENABLED),
> -			 !!(dps0 & DOC_DPS_KEY_OK));
> -	pos += seq_printf(s, "DPS1 = 0x%02x : "
> -			 "Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, "
> -			 "WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
> -			 dps1, dps1_low, dps1_high,
> -			 !!(dps1 & DOC_DPS_OTP_PROTECTED),
> -			 !!(dps1 & DOC_DPS_READ_PROTECTED),
> -			 !!(dps1 & DOC_DPS_WRITE_PROTECTED),
> -			 !!(dps1 & DOC_DPS_HW_LOCK_ENABLED),
> -			 !!(dps1 & DOC_DPS_KEY_OK));
> -	return pos;
> +		seq_puts(s, "NO_PROTECT_ERR");
> +	seq_puts(s, ")\n");
> +
> +	seq_printf(s, "DPS0 = 0x%02x : Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
> +		   dps0, dps0_low, dps0_high,
> +		   !!(dps0 & DOC_DPS_OTP_PROTECTED),
> +		   !!(dps0 & DOC_DPS_READ_PROTECTED),
> +		   !!(dps0 & DOC_DPS_WRITE_PROTECTED),
> +		   !!(dps0 & DOC_DPS_HW_LOCK_ENABLED),
> +		   !!(dps0 & DOC_DPS_KEY_OK));
> +	seq_printf(s, "DPS1 = 0x%02x : Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
> +		   dps1, dps1_low, dps1_high,
> +		   !!(dps1 & DOC_DPS_OTP_PROTECTED),
> +		   !!(dps1 & DOC_DPS_READ_PROTECTED),
> +		   !!(dps1 & DOC_DPS_WRITE_PROTECTED),
> +		   !!(dps1 & DOC_DPS_HW_LOCK_ENABLED),
> +		   !!(dps1 & DOC_DPS_KEY_OK));
> +	return 0;
>  }
>  DEBUGFS_RO_ATTR(protection, dbg_protection_show);
>  

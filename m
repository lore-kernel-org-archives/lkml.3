Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaJWHaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:30:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:46869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbaJWHao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:30:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="623796403"
Date: Thu, 23 Oct 2014 10:30:19 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v1 3/3] tpm: fix multiple race conditions in tpm_ppi.c
Message-ID: <20141023073019.GB5188@intel.com>
References: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413995036-22497-4-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141022172646.GD12775@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022172646.GD12775@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the excellent review comments. I'll do another spin an try to
incorporate most them.

/Jarkko

On Wed, Oct 22, 2014 at 11:26:46AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 22, 2014 at 07:23:56PM +0300, Jarkko Sakkinen wrote:
> > Traversal of the ACPI device tree was not done right. It should lookup
> > PPI only under the ACPI device that it is associated. Otherwise, it could
> > match to a wrong PPI interface if there are two TPM devices in the device
> > tree.
> > 
> > Removed global ACPI handle and version string from tpm_ppi.c as this
> > is racy. Instead they should be associated with the chip.
> > 
> > Moved code just a tiny bit towards two-phase allocation to implement
> > fix for the PPI race conditions.
> 
> Not this version..
> 
> > Added missing copyright platter to tpm_ppi.c.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> I like this one the most of the three I've seen :)
> 
> Did you also look in tpm_acpi.c to see if it needs to use
> acpi_dev_handle somehow too?
> 
> > +	union acpi_object *obj;
> > +	struct kobject *parent = &chip->dev->kobj;
> 
> Nit, this variable is only used once, it would be clearer to inline
> 
> > +	/* Cache PPI version string. */
> > +	obj = acpi_evaluate_dsm_typed(chip->acpi_dev_handle, tpm_ppi_uuid,
> > +				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
> > +				      NULL, ACPI_TYPE_STRING);
> > +       if (obj) {
> > +               strlcpy(chip->ppi_version, obj->string.pointer,
> > +                       PPI_VERSION_LEN + 1);
> > +               ACPI_FREE(obj);
> > +       } else
> > +               return -ENOMEM;
> > +
> > +       return chip->acpi_dev_handle ?
> > +               sysfs_create_group(parent, &ppi_attr_grp) : 0;
> 
> The above sequence can just be:
> 
> if (!obj)
>    return -ENOMEM;
> 
> strlcpy(chip->ppi_version, obj->string.pointer, sizeof(chip->ppi_version));
> ACPI_FREE(obj);
> 
> return sysfs_create_group(&chip->dev->kobj, &ppi_attr_grp);
> 
> Which is more idiomatic. Also remove TPM_PPI_VERSION_LEN, sizeof is better.
> 
> I know nothing about acpi, but is ENOMEM the right code? I would think
> acpi_evalute_dsm_typed would also fail if tpm_ppi_uuid is not found??
> 
> > +	return chip->acpi_dev_handle ?
> > +		sysfs_create_group(parent, &ppi_attr_grp) : 0;
> 
> dev_handle is already checked to be non 0
> 
> > +void tpm_remove_ppi(struct tpm_chip *chip)
> > +	struct kobject *parent = &chip->dev->kobj;
> 
> Also used only once
> 
> Jason

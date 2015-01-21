Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbbAUOZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:25:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60349 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753655AbbAUOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:24:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 15/19] ACPI: Add field offset to struct resource_list_entry
Date: Wed, 21 Jan 2015 15:47:35 +0100
Message-ID: <5866060.ZvSTmUr2GQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BF3B24.10209@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1524434.hGg7sZaCUr@vostro.rjw.lan> <54BF3B24.10209@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 01:37:40 PM Jiang Liu wrote:
> On 2015/1/21 8:53, Rafael J. Wysocki wrote:
> > On Thursday, January 08, 2015 10:33:02 AM Jiang Liu wrote:
> >> Add field offset to struct resource_list_entry to host address space
> >> translation offset so it could be used to represent bridge resources.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> >> ---
> >>  drivers/acpi/resource.c |   13 ++++++++-----
> >>  include/linux/acpi.h    |    1 +
> >>  2 files changed, 9 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> >> index 16d334a1ee25..54204ac94f8e 100644
> >> --- a/drivers/acpi/resource.c
> >> +++ b/drivers/acpi/resource.c
> >> @@ -462,7 +462,8 @@ struct res_proc_context {
> >>  };
> >>  
> >>  static acpi_status acpi_dev_new_resource_entry(struct resource *r,
> >> -					       struct res_proc_context *c)
> >> +					       struct res_proc_context *c,
> >> +					       resource_size_t offset)
> >>  {
> >>  	struct resource_list_entry *rentry;
> >>  
> >> @@ -472,6 +473,7 @@ static acpi_status acpi_dev_new_resource_entry(struct resource *r,
> >>  		return AE_NO_MEMORY;
> >>  	}
> >>  	rentry->res = *r;
> >> +	rentry->offset = offset;
> >>  	list_add_tail(&rentry->node, c->list);
> >>  	c->count++;
> >>  	return AE_OK;
> >> @@ -480,6 +482,7 @@ static acpi_status acpi_dev_new_resource_entry(struct resource *r,
> >>  static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
> >>  					     void *context)
> >>  {
> >> +	resource_size_t offset = 0;
> >>  	struct res_proc_context *c = context;
> >>  	struct resource r;
> >>  	int i;
> >> @@ -500,14 +503,14 @@ static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
> >>  
> >>  	if (acpi_dev_resource_memory(ares, &r)
> >>  	    || acpi_dev_resource_io(ares, &r)
> >> -	    || acpi_dev_resource_address_space(ares, &r, NULL)
> >> -	    || acpi_dev_resource_ext_address_space(ares, &r, NULL))
> >> -		return acpi_dev_new_resource_entry(&r, c);
> >> +	    || acpi_dev_resource_address_space(ares, &r, &offset)
> >> +	    || acpi_dev_resource_ext_address_space(ares, &r, &offset))
> >> +		return acpi_dev_new_resource_entry(&r, c, offset);
> >>  
> >>  	for (i = 0; acpi_dev_resource_interrupt(ares, i, &r); i++) {
> >>  		acpi_status status;
> >>  
> >> -		status = acpi_dev_new_resource_entry(&r, c);
> >> +		status = acpi_dev_new_resource_entry(&r, c, 0);
> >>  		if (ACPI_FAILURE(status))
> >>  			return status;
> >>  	}
> >> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> >> index bde8119f5897..fea78e772450 100644
> >> --- a/include/linux/acpi.h
> >> +++ b/include/linux/acpi.h
> >> @@ -300,6 +300,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
> >>  struct resource_list_entry {
> >>  	struct list_head node;
> >>  	struct resource res;
> >> +	resource_size_t offset;
> > 
> > Well, so instead of adding the offset thing here and there, wouldn't it be
> > cleaner to introduce something like
> > 
> > 	struct ext_resource {
> > 		sturct resource res;
> > 		resource_size_t offset;
> > 	};
> > 
> > and use struct ext_resource instead of struct resource where an offset is needed?
> > 
> > Just a thought ...
> Hi Rafael,
> 	Following patches will achieve this by sharing struct resource_list_entry.

Well, yes, they will partially, but that still won't avoid the need to pass
offset (or pointers to that) to several functions separately if I'm not
mistaken.  Which is kind of ugly.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

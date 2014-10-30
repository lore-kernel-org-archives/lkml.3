Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbaJ3Imw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:42:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:4506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbaJ3Ims (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:42:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="598895300"
Message-ID: <1414658444.23185.23.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: hujianyang <hujianyang@huawei.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>,
        ezequiel.garcia@free-electrons.com,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 30 Oct 2014 10:40:44 +0200
In-Reply-To: <5449C870.7060509@huawei.com>
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
	 <5449C870.7060509@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 11:33 +0800, hujianyang wrote:
> >  	if (len == 0) {
> > -		pr_warn("UBI warning: empty 'mtd=' parameter - ignored\n");
> > +		pr_err("UBI warning: empty 'mtd=' parameter - ignored\n");
> >  		return 0;
> >  	}
> 
> Why the last 'pr_warn()' need to be changed into 'pr_err()'? I looked up your
> V1 and V2 patches, I think it's not your purpose.

Well-spotted, thanks.

> > -static int check_av(const struct ubi_volume *vol,
> > +static int check_av(const struct ubi_device *ubi, const struct ubi_volume *vol,
> >  		    const struct ubi_ainf_volume *av)
> >  {
> >  	int err;
> 
> This patch add 'struct ubi_device *' for 3 functions. We can get 'ubi_device' from
> 'ubi_volume'. So I think it's because when we call these functions, the '->ubi'
> pointer of 'ubi_volume' is not initialized, am I right? This patch use 'vol->ubi'
> to indicate a 'struct ubi_device *' pointer in some places, I think you are sure
> of using them.

Yeah, let's remove the unneeded argument indeed.


> > -	ubi_msg("attached mtd%d (name \"%s\", size %llu MiB) to ubi%d",
> > -		mtd->index, mtd->name, ubi->flash_size >> 20, ubi_num);
> > -	ubi_msg("PEB size: %d bytes (%d KiB), LEB size: %d bytes",
> > +	ubi_msg(ubi, "attached mtd%d (name \"%s\", size %llu MiB)",
> > +		mtd->index, mtd->name, ubi->flash_size >> 20);
> > +	ubi_msg(ubi, "PEB size: %d bytes (%d KiB), LEB size: %d bytes",
> >  		ubi->peb_size, ubi->peb_size >> 10, ubi->leb_size);
> 
> We have the parameter 'ubi_num' for log in some functions like 'ubi_attach_mtd_dev'
> before. This patch remove 'ubi_num' in upper changes but keep it in other changes.
> Do we have a discussed rule to deal with this situation? It's not a big problem~

Well, printing 'ubi_num' explicitely is not needed anymore, so it would
be good to make the code consistent and remove it from other places,
where it is not needed.


> > -		if (kthread_should_stop())
> > +		if (kthread_should_stop()) {
> > +			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
> > +				ubi->bgt_name, task_pid_nr(current));
> >  			break;
> > +		}
> >
> >  		if (try_to_freeze())
> >  			continue;
> 
> Here are two new adding messages. Maybe a separate patch is better? Just a
> suggestion.

Yes, please, remove these messages or turn them into debugging messages.
And yes, these should have been added in a separate patch.

> > @@ -1415,8 +1418,9 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
> >  	return 0;
> >
> >  fail:
> > -	ubi_err("self-check failed for PEB %d", pnum);
> > -	ubi_msg("hex dump of the %d-%d region", offset, offset + len);
> > +	ubi_err(ubi, "self-check failed for PEB %d", pnum);
> > +	ubi_msg(ubi, "hex dump of the %d-%d region",
> > +		 offset, offset + len);
> >  	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
> >  	err = -EINVAL;
> >  error:
> 
> Artem, I know you have tried to align the message code in different lines, maybe
> you can check if you lose this one.

Yeah, lets' correct this too.

Thanks for ferview Hujianyang!

Tanya, would you send a follow-up patch these?

Artem.


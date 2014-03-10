Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaCJPgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:36:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbaCJPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:36:28 -0400
Date: Mon, 10 Mar 2014 11:35:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 09/11] kexec: Provide a function to add a segment at
 fixed address
Message-ID: <20140310153544.GB4352@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-10-git-send-email-vgoyal@redhat.com>
 <20140227215232.GQ18191@pd.tnic>
 <20140228165628.GH28744@redhat.com>
 <20140310100143.GA14808@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310100143.GA14808@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:01:43AM +0100, Borislav Petkov wrote:

[..]
> > I think address does not matter here. You can't add a segemnt after you
> > have allocated a control page. So I am not sure how printing address will
> > help.
> 
> Ok, so what's the urgency of that warning? The "can't add a segment"
> thing sounds kinda final to me and that everything breaks if we do add a
> segment after all, so maybe it should error out with -EINVAL and caller
> should stop adding segments if we have allocated the control page..?
> 
> IOW, how is that error message supposed to help me when I see it as a
> user?

Actually this message is for kernel developer. It is an error for somebody
who has written an kernel image loader.

I think returning -EINVAL is also a good idea. Though it will travel all
the way back to user and user again can't do anything about it. 

I think printing a warning backtrace is still a good idea so that
we know which loader is doing wrong thing and issue can be reported
on lkml.


[..]
> > > That's the retval of validate_ram_range_callback, right? So
> > > 
> > > 	if (!ret)
> > > 
> > > And shouldn't the convention be the opposite? 0 on success, !0 on error?
> > 
> > Ok, this one is little twisted.
> > 
> > walk_system_ram_res() stops calling callback function if callback
> > function returned non zero code.
> > 
> > So in this case, once we have found the range to be valid, we don't want
> > to continue to loop and look at any more ranges. So we return "1". If
> > we return "0" for success, outer loop of walk_system_ram_res() will
> > continue with next ranges.
> 
> Huh, I was only talking about flipping that logic, in walk_system_ram_res():
> 
> 	ret = (*func)(res.start, res.end, arg);
> 	if (!res)
	    ^^^
You mean (!ret) ?

> 		break;
> 
> This way you still can return negative values as errors.

If I flip the logic in walk_system_ram_res() will outer loop not stop
after one round.

walk_system_ram_res() {
	while ((find_next_system_ram(&res, "System RAM") >= 0) {
		ret = (*func)(res.start, res.end, arg);
		if (!ret)
			break;
	}
}

Or are you suggesting that called function should return 0 to break out
of loop otherwise return negative values to continue the loop? But that's
counter intutive. If "func" returns error, then we should break out of
while() loop and not call "func" again with any more qualifiying ranges.

> 
> > Given the fact that "0" is interpreted as success by walk_system_ram_res()
> > and it continues with next set of ranges, I could not use 0 as final
> > measure of success. Negative returns are errors. So I thought of using
> 
> And?
> 
> When the loop finishes, you will have the last negative error in ret...

Yep, Any non-zero value (negative or positive) will be in "ret" when loop
finishes and will be returned to caller. If final return value is negative
caller knows an error occurred. If final return value is positive, caller
knows that *callback* function succeeded. 
> 
> Besides, in load_crashdump_segments() you have:
> 
>         ret = walk_system_ram_res(KEXEC_BACKUP_SRC_START, KEXEC_BACKUP_SRC_END,
>                                 image, determine_backup_region);
> 
>         /* Zero or postive return values are ok */
>         if (ret < 0)
>                 return ret;
> 
> So 0 is ok, as you say.

I kept 0 as ok because I am not enforcing that one found a memory range
with-in 0-640K.

So if return value is 1, we know that we found a RAM memory resource
in the range of 0-640K.  If return value is 0, we did not find a RAM
memory resource in the range of 0-640K. I thought may be there are
systems which don't have memory in that range and system can still
boot. And that's why I said "0" is ok.

I don't want to enforce that one *has* to have a memory range with-in
first 640K otherwise kexec will fail. If there is none, that means there
is no backup region.

> 
> Also:
> 
>         /* Validate memory range */
>         ret = walk_system_ram_res(base, base + memsz - 1, &ksegment,
>                                 validate_ram_range_callback);
> 
>         /* If a valid range is found, 1 is returned */
>         if (ret != 1)
>                 return -EINVAL;
> 
> Now this looks a bit fragile - only 1 is ok? Normally we do it like this:

Only "1" is ok here because I want to make sure that memory range I am
looking for is present and valid. If not, we can't go ahead and it is
an error. (This is different from backup region case).

I can't use 0 as measure of success because walk_system_ram_res() can
return 0 even called function did not succeed. For example, assume
somebody calls walk_system_ram_res() with start=0, end=-1 so that one
walks through all the memory ranges available in the system. Now callback
function probably is loking for a certain range say val1-val2. If
it finds that range in all the ranges, will be return 1, otherwise 
continue to return 0 till we have gone through all the ranges.

So in above case, if 0 is returned, that does not mean callback
function found what it was looking for.

Now one can argue that why are you going through all the memory ranges.
Just search for very narrow area to begin with. Say start=0xval1
and end=0xval2 and now after first range callback function should
be able to determine whether it found the value or not.

But this now becomes dependent on what start and end values were passed
to walk_system_ram_res().

So I am not taking return "0" as measure of success of callback function.
It could just mean that we went through all the overlapping ranges
which matched search criterion and still callback function did not find
what it was looking for.

Thanks
Vivek

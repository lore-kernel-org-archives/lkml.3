Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaETFlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:41:44 -0400
Received: from mail.phunq.net ([184.71.0.62]:37848 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaETFln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:41:43 -0400
From: Daniel Phillips <daniel@phunq.net>
To: Dave Chinner <david@fromorbit.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <tux3@tux3.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Mon, 19 May 2014 22:41:40 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <a3b84e5d-454d-41cc-a728-6dd6399c5b18@phunq.net>
In-Reply-To: <20140520031802.GF18954@dastard>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 19, 2014 8:18:02 PM PDT, Dave Chinner wrote:
> On Mon, May 19, 2014 at 05:55:30PM -0700, Daniel Phillips wrote:
>> On 05/18/2014 04:55 PM, Dave Chinner wrote:
>  ...
>
> I'm not commenting on the c99 comment style, I'm passing comment on
> the fact that a filesystem that has commented out code from *other
> filesystems* is in no shape to be merged.

I do not feel at all ashamed of mentioning Ext4 in our code where it makes 
sense. After all, we actually cut and pasted our whole dir.c from Ext3 
originally. But this hurts your eyes, so:

static const struct inode_operations tux_file_iops = {
        /*.permission   = tux3_permission,*/
        .setattr        = tux3_setattr,
        .getattr        = tux3_getattr,
#ifdef CONFIG_TUX3_XATTR
        /*.setxattr     = generic_setxattr,*/
        /*.getxattr     = generic_getxattr,*/
        /*.listxattr    = tux3_listxattr,*/
        /*.removexattr  = generic_removexattr,*/
#endif
        /*.fallocate    = tux3_fallocate,*/
        /*.fiemap       = tux3_fiemap,*/
        .update_time    = tux3_file_update_time,

Why those ones are commented out: fiemap is not important right now; 
fallocate is advisory; tux3 only has xattrs in user space not kernel yet, 
and initial users are unlikely to care; we don't need .permission until 
xattrs are exposed.

>>> The hacks around VFS and MM functionality need to have demonstrated
>>> methods for being removed. We're not going to merge that page
>>> forking stuff (like you were told at LSF 2013 more than a year ago:
>>> http://lwn.net/Articles/548091/) without rigorous design review and
>>> a demonstration of the solutions to all the hard corner cases it
>  ...
>> Thank you. A design review, hack by hack, is exactly what we want.
>> Would you prefer to do them all at once, or one at a time?
>
> First you need to write the patches that we'll review. Then send
> them once you have them functionally complete, working and ready to
> go.

I'll hold you to that review offer :) Our patch bomb is on the way.

>>> The current code doesn't solve them (e.g. direct IO doesn't
>>> work in tux3), and there's no clear patch set we can review that
>>> demonstrates how it is all supposed to work.
>> If you don't mind, we will leave direct IO for after merge. Direct
>> IO is an enterprise feature on our to-do list, but Implementing it
>> right now does not seem like a good reason to continue working out
>> of tree. We would be happy to discuss our approach to direct IO if
>> you wish.
>
> Except that Direct IO impacts on the design of the page forking code
> (because of how things like get_user_pages() need to be aware of
> page forking). So you need to have direct IO working to demonstrate
> that the page forking design is sound.....

We will deal with direct IO when we get to it. It is low on the list of 
features that users of personal and embedded devices actually want.

>>> ...
>> We decided to add the versioning after merge because there seems to
>> be no shortage of people who are more interested in base
>> functionality like performance and reliability than snapshotting.It
>  ...
>
> You completely missed my point. We don't *need* tux3 as it currently
> implemented in the mainline tree. You keep saying "performance and
> reliability" as reasons to merge code that is not clean, stable or
> reliable, nor is the performance of that code at all proven to be
> superior to the our supported production filesystems.

I disagree that Tux3 is not clean. Yes there are warts, but aren't there 
always. I also disagree that Tux3 is not stable or reliable. That remains 
to be seen. Tux3 passes our stress tests and yours. I have no doubt that 
issues will come up, but that is the case even for filesystems that have 
been merged for years.

> The development of btrfs has shown that moving prototype filesystems
> into the main kernel tree does not lead stability, performance or
> production readiness any faster than if they stayed as an
> out-of-tree module until most of the development was complete. If
> anything, merging into mainline reduces the speed at which a
> filesystem can be brought to being feature complete and production
> ready....

Tux3 is beyond the prototype stage and so was Btrfs when it was merged. I 
am glad that Btrfs was merged before it was ready. It had a rough ride for 
a few years and there is still more of that coming, but they stuck with it 
and made something impressive. Without that, Linux would still have no 
answer to ZFS.

I doubt that you can support your argument about merging slowing down 
development. From what I have seen, it tends to light a fire under the 
development team's collective tail. Somebody ought to do a study.

> ....
>
>> As I said, the glaring omission is proper ENOSPC handling, which is
>> work in progress. I do not view that as an obstacle to merging.
>> 
>> After all, Btrfs did not have proper ENOSPC handling when it was
>> merged.
>
> Yup, and that was a big mistake. Hence not having working ENOSPC
> detection is a major strike against merging a new filesystem now.
>
>> The design is here:
>
> So come back when you've implemented it properly and proven that you
> have a sound design and clean implementation.

Whether a completed, perfect implementation of ENOSPC is a precondition for 
merging is up to Andrew or Linus. If you feel that my ENOSPC design is not 
sound, please be specific.

I really like the approach of shrinking down the delta size as the volume 
fills up. I would go so far as to say that it is obviously correct. The 
implementation looks clean so far. I intend to continue working on it 
during review of our current code base. 

Regards,

Daniel

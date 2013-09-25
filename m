Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3IYDil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:38:41 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:60101 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3IYDij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130924002042.GW13318@ZenIV.linux.org.uk>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
	<20130924002042.GW13318@ZenIV.linux.org.uk>
Date: Wed, 25 Sep 2013 11:30:19 +0800
Message-ID: <CAEH94LinWGJzdg3nugbF=+1b_vH7cZWhDgno=T7paKSJLEG3XQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] VFS hot tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 8:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Sep 17, 2013 at 06:17:45AM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   The patchset is trying to introduce hot tracking function in
>> VFS layer, which will keep track of real disk I/O in memory.
>> By it, you will easily know more details about disk I/O, and
>> then detect where disk I/O hot spots are. Also, specific FS
>> can take use of it to do accurate defragment, and hot relocation
>> support, etc.
>>
>>   Now it's time to send out its V5 for external review, and
>> any comments or ideas are appreciated, thanks.
>
> FWIW, the most fundamental problem I see with this is that the data
> you are collecting is very sensitive to VM pressure details.  The
> hotspots wrt accesses (i.e. the stuff accessed all the time) will
> not generate a lot of IO - they'll just sit in cache and look
> very cold for your code.  The stuff that is accessed very rarely
> will also look cold.  The hot ones will be those that get in and
> out of cache often; IOW, the ones that are borderline - a bit less
> memory pressure and they would've stayed in cache.  I would expect
> that to vary very much from run to run, which would make its use
> for decisions like SSD vs. HD rather dubious...
Are you suggesting to collect the hot info when the data is accessed
while in cache?
Of course, i will do the perf testings in some scenarios where VFS hot
tracking is taking effect.
>
> Do you have that data collected on some real tasks under varying
> memory pressure conditions?  How stable the results are?
Can you say what some real tasks are with more details? What kind of
tests are you suggesting? and what results are you expecting to see?
>
> Another question: do you have perf profiles for system with that
> stuff enabled, on boxen with many CPUs?  You are using a lot of
No, i will try to do it, and let you know its result.
> spinlocks there; how much contention and cacheline ping-pong are
> you getting on root->t_lock, for example?  Ditto for cacheline
> ping-pong on root->hot_cnt, while we are at it...
Sorry, What kind of tests are you suggesting? and what results are you
expecting to see? You know, i am one newbie for VFS, can you say with
more details? how to do this test?
>
> Comments re code:
>
> * don't export the stuff until it's used by a module.  And as
> a general policy, please, do not use EXPORT_SYMBOL_GPL in fs/*.
> Either don't export at all, or pick a sane API that would not
> expose the guts of your code (== wouldn't require you to look
> at the users to decide what will and will not break on changes
> in your code) and export that.  As far as I'm concerned,
> all variants of EXPORT_SYMBOL are greatly overused and
> EXPORT_SYMBOL_GPL is an exercise in masturbation...
OK, i will make appropriate change based on your comments, thanks.
>
> * hot_inode_item_lookup() is a couple of functions smashed together;
> split it, please, and lose the "alloc" argument.
Do you mean that it should be split into two functions "alloc"
function and "lookup" function?

>
> * hot_inode_item_unlink() is used when the last link is killed
> by unlink(2), but not when it's killed by successful rename(2).
> Why?
Since we are using inode for collecting the hot info, rename(2)
doesn't destroy that information as inodeis kept the same.
>
> * what happens when one opens a file, unlinks it and starts doing
> IO?  hot_freqs_update() will be called, re-creating the inode item
> unlink has killed...
Since the file won't be opened and used anymore by anybody else we
don't bother about it.
But i will improve it based on your comments. hot_freqs_update() will
directly return and not re-create the inode item when this file has
been unlinked.
>
> * for pity sake, use inlines - the same hot_freqs_update() on a filesystem
> that doesn't have this stuff enabled will *still* branch pretty far
> out of line, only to return after checking that ->s_hot_root is NULL.
> Incidentally, we still have about twenty spare bits in inode flags;
> use one (S_TEMP_COLLECTED, or something like that) instead of that
> check.  Checking it is considerably cheaper than checking ->i_sb->s_hot_root.
OK, will use inline and bits flag in the next post, thanks.
>
> * hot_bit_shift() is bloody annoying.  Why does true mean "up", false -
> "down" and why is it easier to memorize that than just use explicit <<
> and >>?
OK, will make appropriate changed based on your comments, thanks.
>
> * file->f_dentry->d_inode is spelled file_inode(file), TYVM (so does
> file->f_path.dentry->d_inode, actually).
Ditto.
>
> * #ifdef __KERNEL__ in include/linux/* is wrong; use include/uapi/linux/*
> for the bits userland needs to see.
Ditto.
>
> * checks for ->i_nlink belong under ->i_mutex.  As it is, two unlink(2)
> killing two last links to the same file can very well _both_ call
> hot_inode_item_unlink(), with obvious unpleasant results.
Ditto.



-- 
Regards,

Zhi Yong Wu

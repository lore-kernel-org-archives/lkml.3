Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaDMHwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 03:52:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56020 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaDMHwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 03:52:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
	<87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
Date: Sun, 13 Apr 2014 00:51:56 -0700
In-Reply-To: <87zjjp3e7w.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Sun, 13 Apr 2014 00:01:23 -0700")
Message-ID: <87ppkl1xb7.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+zuQ/sCNISfDB23WcCOJm0+QweowBR7aA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4071]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow stack.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Al Viro <viro@ZenIV.linux.org.uk> writes:
>
>> On Sat, Apr 12, 2014 at 03:15:39PM -0700, Eric W. Biederman wrote:
>>
>>> Can you explain which scenario you are thinking about with respect to a
>>> failed modprobe?
>>
>> Again, it's not impossible to audit (there's not a lot of places where
>> struct file_system_type * is ever stored, there are few instances of
>> struct file_system_type, all statically allocated, etc.), but it's
>> a non-trivial amount of work.  And I honestly don't know if we have
>> any such places right now.  Moreover, unless you feel like repeating
>> that kind of audit every merge window, we'll need a some way of dealing
>> with such situations.  Something like flush_pending_mntput(fs_type), for
>> example, documented as barrier to be used in such places might do, but
>> if you can think of something more fool-proof...
>
> I performed a quick audit and I don't see that case happening in the
> current code.  

Sigh.  I was wrong.  Almost this exact case happens in
btrfs_init_test_fs, and of course I was silly when I thought the module
ref count would be useful for something before init_module succeeds.

Still I suspect I was on the right track.  We do have the get_fs_type,
get_filesystem and put_filesystem.  Which ought to be enough to allow
us to convert unregister_filesystem into an appropriate barrier.

Something to look at after I have slept.

Eric



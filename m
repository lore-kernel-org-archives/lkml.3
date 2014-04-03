Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaDCXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:18:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58071 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaDCXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:18:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
	<CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
	<CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
	<CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
	<20140403194335.GC2472@mtj.dyndns.org>
Date: Thu, 03 Apr 2014 16:18:03 -0700
In-Reply-To: <20140403194335.GC2472@mtj.dyndns.org> (Tejun Heo's message of
	"Thu, 3 Apr 2014 15:43:35 -0400")
Message-ID: <87bnwic89g.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19G1qpaV0aTe1kXpKL0cgTRwgUQf8//Nto=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3289]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Thu, Apr 03, 2014 at 12:01:23PM -0700, Linus Torvalds wrote:
>> [ Extending the participants list a bit ]
>> 
> As for using specific type for ns tag, yeah, that'd be better
> regardless of this.  The opaqueness is a bit extreme now.

(The opaqueness has alwasy been silly but it was the compromise
 required to get the code merged.  Sigh)

With respect to cleaning up the namespace opaqueue pointers while
working on the sysctls I came up with a design that is quite a bit
more maintainable.

The basic idea in terms of kernfs is to have an array (sized 1 for now)
in the superblock of pointers to root kernfs_nodes.  Then you have a
nslink node type that holds the index of the kernfs_node pointer it is
associated with.  When following a nslink (which is unconditional
because they would not be visible to userspace) the appropriate root
kernfs_node is selected from the superblock and traversed to the same
path as the nslink.

The major benefit is that except for special cases in mounting (to
populate the extra root), and following the nslink there is no extra
logic to worry about or deal with.

Since that winds up using ordinary kernfs_nodes, which are already
reference counted in a well understood way we should be able to
completely remove passive refcount to the network namespace.

Since it has been clear what is needed for 3.15 and for resolving the
merge conflict I am not suggesting we do anything this merge window but
since we are talking about how to clean up warts in the existing design,
I figured I should mention it.

Eric


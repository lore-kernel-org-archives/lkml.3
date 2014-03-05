Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaCESGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:06:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:39502 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCESGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:06:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, David Miller <davem@davemloft.net>, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
References: <20140304133004.b565820f60f595a48e621e58@linux-foundation.org>
	<87mwh5d1tf.fsf@xmission.com>
	<20140304.192152.1234652192226780071.davem@davemloft.net>
	<7457128.6VP2v68V93@x2>
Date: Wed, 05 Mar 2014 10:06:23 -0800
In-Reply-To: <7457128.6VP2v68V93@x2> (Steve Grubb's message of "Wed, 05 Mar
	2014 11:59:01 -0500")
Message-ID: <87wqg8zfj4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+kFPujyyqQVSSKYqycsRXaBjpPaOFe0SM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 T_FRT_STOCK2 BODY: ReplaceTags: Stock (2)
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Steve Grubb <sgrubb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket buffer is large enough
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Grubb <sgrubb@redhat.com> writes:

> On Tuesday, March 04, 2014 07:21:52 PM David Miller wrote:
>> From: ebiederm@xmission.com (Eric W. Biederman)
>> Date: Tue, 04 Mar 2014 14:41:16 -0800
>> 
>> > If we really want the ability to always appened to the queue of skb's
>> > is to just have a version of netlink_send_skb that ignores the queued
>> > limits.  Of course an evil program then could force the generation of
>> > enough audit records to DOS the kernel, but we seem to be in that
>> > situation now.  Shrug.
>> 
>> There is never a valid reason to bypass the socket limits.
>> 
>> It protects the system from things going out of control.
>> 
>> Netlink packet sends can fail, and audit should cope with that
>> event instead of trying to bludgeon it into not happening.
>
> I am not sure what exactly is the problem with the code that was being 
> patched. The audit code has been stable and working pretty well for everyone 
> for the last 5-6 years. But lately there has been a lot of kernel code churn 
> and I am concerned that the changes are being made without a complete 
> understanding of the design goals.

The problem is that the audit code in the kernel is not using netlink
correctly and which leads to mistakes when the code is updated because
the code in the kernel is unnecessarily complex, and inefficient.

> The audit system has to be very reliable. It can't lose any event or record. 
> The people that really depend on it would rather have access denied to the 
> system than lose any event. This is the reason it goes to such
> lengths.

But the designers of the code didn't really go to any lengths at all.
There are enormous and cumbersome hacks to avoid fixing the kernel
interfaces to do what audit wants to use the kernel interfaces for.
That is the audit code for transmitting replies is stupid and is causing
serious maintenance issues, by growing hacks upon hacks instead of
dealing with the core issues.

The first approximation of what you want should have been be to set the
netlink socket recvbuf to as large as the can be:
setsockopt(sk, SOL_SOCKET, SO_RCVBUFFORCE, INTMAX);

If/when 2GiB is shown to be not enough people should should have worked
on the netlink layer to allow even larger piles of audit messages to be
in flight, assuming you really do want to bring down the system when the
audit client is just too slow.

> If I understand the patch, it looks like its affecting code that adds, deletes, 
> or lists audit rules. This code is quite old and working well. It didn't at 
> first. We found a lot of problems by writing scripts like:

Working well does not mean implemented well, and for a security feature
not implemented well means broken.  And frankly since I can't see a
single setsockopt to set the received buffer size for audit netlink
sockets I have to stronlgy suspect that people were working around
userpsace bugs with stupid kernel code.

> #!/bin/bash
> while [ 1 ] ;
> do
>         echo "Inserting syscalls..."
>         sys=1
>         while [ $sys -lt 100 ]
>         do
>                 sys=`expr $sys + 1`
>                 echo "$sys"
>                 auditctl -a entry,always -S $sys
>         done
>
>         echo "Listing..."
>         auditctl -l
>         echo "Deleting..."
>         auditctl -D
> done
>
> with another shell running:
>
> #!/bin/bash
> while [ 1 ] ; 
> do
> 	echo "Listing..."
> 	auditctl -l
> done
>
> and another shell running:
>
> #!/bin/bash
> while [ 1 ] ; 
> do
> 	echo "Disabling..."
> 	auditctl -e 0
> 	echo "Enabling..."
> 	auditctl -e 1
> done
>
> You can probably imagine more stress tests. But the proposed code should be 
> well tested similar to this.

Honestly since no one cares enough to maintain the kernel code properly
I really think we should just rip audit out instead trying to present
userspace with the delusion that the code works, and will continue to
work properly.

My apologies for being grumpy.  I have no intention of breaking
userspace (which is why my last patch was an rfc) but at the same time
I care absolutely nothing about audit.  It solves none of my problems
and works at all of the wrong layers to be interesting for me.

I just happened to notice that the code has been broken since 3.14-rc1
and no one understands or cares enough about audit to even accept
trivial kernel patches to fix the bugs.  No offense but I am not
interested in testing code I care nothing about, especially when there
is no one to pick up the patches.  My RFC patch was supposed to be a
word to the wise.

Eric

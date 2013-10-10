Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3JJKW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:22:27 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:16680 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab3JJKW0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:22:26 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peng, Arthur" <Arthur.Peng@sonymobile.com>,
        "Zhang, Bojie" <Bojie.Zhang@sonymobile.com>
Date: Thu, 10 Oct 2013 18:22:21 +0800
Subject: RE: BUG report about ipt_do_table( )
Thread-Topic: BUG report about ipt_do_table( )
Thread-Index: Ac7FneG/wMIB3geZS0yZ5fCLjND6mAAAUsEA
Message-ID: <35FD53F367049845BC99AC72306C23D1014D1A0971B4@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
 <20131010094824.GF3817@mudshark.cambridge.arm.com>
In-Reply-To: <20131010094824.GF3817@mudshark.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi   Will,

Thanks for your reply .

This is the kernel that we use:

https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/net/ipv4/netfilter/ip_tables.c?id=M8960AAAAANLYA26144005
https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/net/netfilter/x_tables.c?id=M8960AAAAANLYA26144005



I am sorry that I can't use the latest kernel to reproduce
This BUG, make the new kernel running on our 
Platform is not easy, and need do a lot of porting work .

I have compare our kernel with 3.12 ,  
Ip_tables.c x_tables.c  is the same ,
So the BUG should can also be reproduce on 3.12 (just my guess).


I make a patch for this BUG, but have not test it:


/-----------------------------------------------------------------------/
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8d987c3..2353bcc 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -819,6 +819,12 @@ xt_replace_table(struct xt_table *table,
 		return NULL;
 	}
 
+	/*
+	 * make sure the change is write to the memory
+	 * so that the other CPU can see the changes
+	 */
+	mb();
+
 	/* Do the substitution. */
 	local_bh_disable();
 	private = table->private;

/-----------------------------------------------------------------------/


I add a memory barrier before update table->private .
Make sure the other CPU can see the update memory correctly.
When the BUG happened, the other CPU can get the new private (struct xt_table_info *),
But sometimes it see private->jumpstack == NULL  , or sometimes it see private->jumpstack[cpu] == NULL ,

Our several crash dumps show different crash point .

This is caused by CPU write buffer ? 
It has written table->private , but has not update private-> members (still in write buffer)  ,
This is really out of order write, will this happened on modern armv7 CPU?
Especially like cortex-a15 , it can execute code out of order .


Thanks you .


-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Thursday, October 10, 2013 5:48 PM
To: Wang, Yalin
Cc: 'linux-arm-msm-owner@vger.kernel.org'; linux-kernel@vger.kernel.org
Subject: Re: BUG report about ipt_do_table( )

On Thu, Oct 10, 2013 at 06:16:05AM +0100, Wang, Yalin wrote:
> Dear all,

Hello,

> We encounter a crash in ipt_do_table( ) function During our stability 
> test .
> 
> The CPU is  qcom msm8960 / dual core  , linux kernel version is 3.4

I appreciate that this is a mammoth task, but can you reproduce this failure with a mainline kernel (3.12-rc4)? If you suspect a synchronisation issue in core code, I'm afraid you'll have to show the failure with the current sources.

Will

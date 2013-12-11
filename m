Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3LKJkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:40:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42668 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3LKJkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:40:37 -0500
X-AuditID: cbfee6a4-b7fb26d000006a49-9c-52a8331279f1
Date: Wed, 11 Dec 2013 09:40:34 +0000 (GMT)
From: Anurag Aggarwal <a.anurag@samsung.com>
Subject: Re: [PATCH V6] ARM : unwinder : Prevent data abort due to stack
 overflow
To: Dave Martin <Dave.Martin@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Kumar <naveen.sel@samsung.com>,
        Narendra Meher <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashish Kalra <ashish.kalra@samsung.com>, "cpgs ." <cpgs@samsung.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        Poorva Srivastava <poorva.s@samsung.com>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>
Reply-to: a.anurag@samsung.com
MIME-version: 1.0
X-MTR: 20131211092524934@a.anurag
Msgkey: 20131211092524934@a.anurag
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131211092524934@a.anurag
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: Y
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <2150956.98751386754831696.JavaMail.weblogic@epml23>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/t6bpCxiuCDI52SVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Md7vnMxZM4q9Yt8StgfEOXxcjJ4eQgLJE7971bCC2hICJxLKG
	x0wQtpjEhXsQcSGB+YwSzz6pdTFycLAIqEp86rcECbMJ6EpMvHGFGcQWFgiUOHb/EDtIiYiA
	usTRfUAlXBzMArtYJaY2vWGFGCMncXfddrB6XgFBiZMzn7BArFKU+NZ0nA0iriRxsX0V1Aly
	EkumXoayeSVmtD9lgYlP+7qGGcKWljg/awMjzMmLvz+GivNLHLu9gwnkHpDeJ/eDYcbs3vwF
	6lsBialnDkK1qkncXdvMDmHzSaxZ+JYFZsyuU8uZYXobNv4Gq2EGOnlK90Mo20DiyKI5rOje
	4hVwkHj5/yLzBEa5WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9AoTveLE3OLSvHS95PzcTYzg
	CH+2ZAdjwwXrQ4wCHIxKPLwHi5YHCbEmlhVX5h5ilOBgVhLhXcGwIkiINyWxsiq1KD++qDQn
	tfgQozQHi5I474JbSUFCAumJJanZqakFqUUwWSYOTqkGxtWLXjy6NuHS75Odquvt1J8eb/c4
	ahN9rsNsU4FvkeIiwS+FrX+upPGWHF8ZGjQpREbttQ3/ZR7+uK/S4se+nM3s+q4efKbB6qZZ
	berNjym2xutupjQ/dyjd88Ws/YT1hYPLWA8/XhPKL/VowdxlR1xVLj12KXGw0OG+W/Z70uHL
	Z8QnO137EaXEUpyRaKjFXFScCACpBuDv7AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBB9emgP023586

>You could try adding some debug printks to see how the backtrace fails.
>You could also try adding a few hand-crafted assembler functions
>with appropriate code and unwind directives to trigger different kinds
>of backtrace failure.  You might have to add a way to artificially limit
>sp_high to check the cases where you run out of stack in the middle of
>popping multiple registers.

I added a a printk statement 
+               if (*vsp >= (unsigned long *)ctrl->sp_high) {
+                       printk(KERN_ERR "Stack Overflow Detected, vsp = %lx",
+                               (unsigned long)*vsp);
+                       return -URC_FAILURE;
+               }

I ran a many test cases to try and get the above print in the dmesg log.

I tried the following things :

1) Calling unwind_backtrace from diffrenet locations in the kernel, I added the unwind call 
in some irq, fork, exit and some sysfs entries call.
2) I limited the value of sp_high in unwind_frame() itself, I tried many values of sp_high, 
varrying from (low + sizeof(ctrl.vrs)/4) to (low + 4*sizeof(ctrl.vrs)).

When running the above cases I was able to see the above printk quiet a few times in dmesg log.

So, the error condition is being handled.

If you have some test cases for verifying the unwinder, please share the same. They might help 
in thorough testing of unwinder.



Regards
AnuragˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

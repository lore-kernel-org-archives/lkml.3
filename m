Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab3E3Bl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:41:56 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:11343 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759787Ab3E3Blr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:41:47 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>
CC: "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 30 May 2013 09:41:42 +0800
Subject: RE: A bug about system call on ARM
Thread-Topic: A bug about system call on ARM
Thread-Index: Ac5cUcBEOcplY4MiTAaUd2fm1B5t7AAAByAQACEm8AA=
Message-ID: <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1610991B85B@CNBJMBX05.corpusers.net>
 <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
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

Hi  Will,

Have you received the log files?

And is there someone looking at this issue now ?
This issue happened on Qcom Scorpoin CPUs,
And  it just happened in our stability test occasionally .

If you have some patch for this issue,
I can do the test for it .

Thanks for your help very much !

-----Original Message-----
From: Wang, Yalin 
Sent: Wednesday, May 29, 2013 5:51 PM
To: 'Will Deacon'; richard -rw- weinberger
Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: RE: A bug about system call on ARM

Hi 

This is kernel.log  and  the stack which is recovered by Trace32 tools.
Please have a look at it .

Thanks 

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com]
Sent: Wednesday, May 29, 2013 5:48 PM
To: richard -rw- weinberger
Cc: Wang, Yalin; linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: A bug about system call on ARM

Hello,

On Wed, May 29, 2013 at 09:46:42AM +0100, richard -rw- weinberger wrote:
> On Wed, May 29, 2013 at 10:24 AM, Wang, Yalin <Yalin.Wang@sonymobile.com> wrote:
> > I have download the latest linux kernel code  3.9.4 And Compare with
> > 3.4.0 kernel .
> >
> > It seems there is no change for this part , So it will still happen 
> > .
> > Does anyone know who is responsible for  arm arch part kernel code ?
> 
> See MAINTAINERS file.
> CC'ing linux-arm-kernel@lists.infradead.org

Cheers for adding us to CC.

> >> #ifdef CONFIG_ARM_THUMB
> >>         tst     r8, #PSR_T_BIT
> >>         movne   r10, #0                         @ no thumb OABI emulation
> >>         ldreq   r10, [lr, #-4]                  @ get SWI instruction          // crash at this instruction, when get SWI instruction

Do you have the panic log please? Also, which SoC are you using and how are you reproducing this?

> >>         ldr     r10, [lr, #-4]                  @ get SWI instruction
> >>   A710( and     ip, r10, #0x0f000000            @ check for SWI         )
> >>   A710( teq     ip, #0x0f000000                                         )
> >>   A710( bne     .Larm710bug                                             )
> >> #endif
> >> #ifdef CONFIG_CPU_ENDIAN_BE8
> >>         rev     r10, r10                        @ little endian instruction
> >> #endif
> >>
> >> /******************************************************************
> >> ***
> >> ******************************/
> >>
> >> Then reason why it will crash when get SWI instruction is maybe 
> >> This page is clear to aged by kernel, But this MMU fault happpened 
> >> in kernel, So the kernel do_page_fault function will not clear this 
> >> page to young, So that  will crash .

Sounds like we might need some USER annotations around the instruction loads, but we should also rework the code so that we re-enable interrupts first.

Will

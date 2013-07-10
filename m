Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3GJRmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:42:17 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:60255 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3GJRmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:42:15 -0400
X-AuditID: cbfec37b-b7f306d0000047de-58-51dd9cf5c763
From: Shuah Khan <shuah.kh@samsung.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [Intel-gift] Linux 3.10-rc7
Thread-topic: [Intel-gift] Linux 3.10-rc7
Thread-index: Ac59gJi9domNTZLbT4OS9A/79ZioNQ==
Date: Wed, 10 Jul 2013 17:42:12 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617382FC@sisaex02sj>
References: <5B8DA87D05A7694D9FA63FD143655C1B028E5075@HASMSX106.ger.corp.intel.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9hX92vc+4GGiy/pGFx9dYCJouFD+8y
	W8yesJnJ4vKuOWwW/Qt7mSy+/nSw+NBTZ/Go7y27A4fH3m8LWDx2zrrL7rF4z0smjxMzfrN4
	3O8+zuTxft9VNo9Hi1sYPT5vkgvgiOKySUnNySxLLdK3S+DKeLE1uOC4aMXn09dYGhgvC3Yx
	cnJICJhIHNp8iwXCFpO4cG89WxcjF4eQwDJGiT3/FrBAOL1MEhdPL2eFcOYzSvxtW8oO0sIm
	oC7x+fUOMFtEQE/i1uo57CBFzALtzBI/zy5lBEkIC2hI7Gt5ywpRpCnx69wtuIYjM5cDreDg
	YBFQlVg41xUkzCtgL9HyegrYSUICoRKLvz0HsxmBzvt+ag0TiM0sIC7R3HoT6mwBiSV7zjND
	2KISLx//YwUZKSGgKLF9tRVEuZbE+p3HoVq1JZ68u8AKsUpQ4sfkeywTGMVmIZk6C0nLLCQt
	s5C0LGBkWcUoVlqcXFCclJ5aYaRXnJhbXJqXrpecn7uJERKz1TsY7361OcQowMGoxMOrEXs3
	UIg1say4MvcQowQHs5II78kpQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MTPFr/BUFOl69rzNa
	biFz4KPb26IUK+0iyY+3nXzKqveamU355eXHeT3sYe+PnJ38xxM+73g6c3FnKI//U7dTBodi
	Xz84oHA197d3oabND/MOt9SNVi2rHqYt+Nqk0/u/RdLyee8p7+97NbJ+5LA82//q1anXk0rU
	TQUXCwWuX9PMwDclPzpKiaU4I9FQi7moOBEAb9dP3LcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 09:18 AM, Winkler, Tomas wrote:
>>> suspend complete.
>>>
>>> I can start bi-sect of this problem on intel-display scope if you
>>> would like me to. Please let me know if the bisect scope should be larger.
>>>
>>> -- Shuah
>>
>> I got finally an older system where this reproduces consistently, I'm trying to
>> root cause that now.
>> As soon I have something to test I will send it out.
>>
>
> I'm not sure why but I'm not able to get the interrupt from the device until all the devices has resumed after that the mei reset is successful and device work as expected.
> I need to fix the state machine so the reset won't go crazy on resetting  actually I did that and it reduces resets into two but I'm still trying to figure out what's going on.
> The regression coming from the fact that I've linearize the reset flow, it waits for interrupt to arrive, before that the flow gave up and  has restarted directly from the interrupt thread.
>
>
> Thanks
> Tomas
>
>

Tomas,

This might be a shot in the dark. Commit  mei: me: clear interrupts on 
the resume path (42f132febff3b7b42c6c9dbfc151f29233be3132), clears 
pending interrupts in mei_me_pci_resume(). Your comment about not seeing 
interrupt until mei reset is successful got me wondering, if clearing 
pending interrupts is causing this?

I don't see mei_me_pci_suspend() calling mei_disable_interrupts() and 
pci_disable_msi(). I don't see a call to mei_enable_interrupts() from 
mei_me_pci_resume(). I don't think mei_enable_interrupts() is used 
anywhere. pci_dev_msi_enabled() enables the interrupts in
mei_me_pci_resume() looks like.

However, I did notice one thing, if pci_dev_msi_enabled() returns false, 
request_threaded_irq() is called  with IRQF_SHARED. Again might just be 
fine, it leads me to the next question.

mei_me_pci_suspend() has code that runs after disabling interrupts. Does 
this need to be split into suspend() and suspend_noirq() ops, since the 
IRQ could be shared?

It is a possibility if pci_enable_msi() takes longer in resume path and 
pci_dev_msi_enabled() returns false, then IRQF_SHARED is requested.

Don't know if this helpful, but I thought I would ask just in case, it 
helps you think of something you didn't before. Please let me know if 
you need help gathering data from my system.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658

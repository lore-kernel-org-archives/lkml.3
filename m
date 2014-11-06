Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKFBgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:36:22 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:35696 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKFBgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:36:19 -0500
Message-ID: <545AD080.9080408@laposte.net>
Date: Thu, 06 Nov 2014 02:36:00 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Chuansheng Liu <chuansheng.liu@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com> <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com> <545A7087.3050802@laposte.net> <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
In-Reply-To: <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrhedvgdduuddvucetufdoteggodetrfcurfhrohhfihhlvgemucfpfgfogfftkfevteeunffgnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkfffhfgggvffufhgjtgfgsehtkegrtddtfeejnecuhfhrohhmpeeurghrthhouceomhhishhtvghrrdhfrhgvvghmrghnsehlrghpohhsthgvrdhnvghtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn : the patch initialy created for bug  81551 ( ATAPI-CD-ROM-drive
dead after resume from suspend/s2disk ) was not enough for the bug 84861
( JMicron Technology Corp. JMB368 IDE controller dead after resume when
async suspend is enabled ),

the reason : there are too much models inside the family of JMBxxx
JMicron SATA/IDE controlers PCI cards,  and the first patch targets ONLY
the JMB363/361 model, which is not enough :

if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
+		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
+		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+		device_disable_async_suspend(&pdev->dev);

for example I have a JMB363/368 JMicron SATA/IDE PCI card, and the first
patch created for the bug 81551 is not enough, that's why Chuansheng Liu
created a new patch who targets ALL models of JMicron JMBxxx SATA/IDE
cards, in order to be sure that these models of JMicron will have
"async_suspend feature disabled,

the good patch who works for all models of JMicron JMBxx SATA/IDE
controlers :

+     if (dev->vendor != PCI_VENDOR_ID_JMICRON)
+         device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;

	



Le 05/11/2014 20:03, Bjorn Helgaas a écrit :
> On Wed, Nov 5, 2014 at 11:46 AM, Barto <mister.freeman@laposte.net> wrote:
>> this patch solves these 2 bug reports :
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=81551
> 
> Those bugs were already mentioned.  But e6b7e41cdd8c claims to solve
> https://bugzilla.kernel.org/show_bug.cgi?id=81551, and 84861 is a
> duplicate of 81551, so it should also be fixed by e6b7e41cdd8c.
> 
> So the question is, why was e6b7e41cdd8c insufficient?  Presumably it
> was tested and somebody thought it did fix the problem.
> 
>> in simple words : JMicron IDE/Sata controlers family ( JMBxxx ) are not
>> fully compatible with async_suspend feature, when a user tries to put
>> his PC on standby mode then at wake-up JMicron IDE/Sata controlers will
>> not work, because of a brother-relation between the SATA and IDE part on
>> this JMicron PCI card
>>
>>
>>
>>
>> Le 05/11/2014 19:01, Bjorn Helgaas a écrit :
>>> On Tue, Nov 4, 2014 at 6:31 PM, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>>>> The JMicron chip 361/363/368 contains one SATA controller and
>>>> one PATA controller, they are brother-relation ship in PCI tree,
>>>> but for powering on these both controller, we must follow the
>>>> sequence one by one, otherwise one of them can not be powered on
>>>> successfully.
>>>
>>> This should mention what's broken and what problem a user would see.
>>> This changelog sounds a lot like the one for e6b7e41cdd8c, so I don't
>>> know if this is for a new, related problem, or what.
>>>
>>>> So here we disable the async suspend method for Jmicron chip.
>>>>
>>>> Bug link:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=81551
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=84861
>>>>
>>>> And we can revert the below commit after this patch is applied:
>>>> e6b7e41(ata: Disabling the async PM for JMicron chip 363/361)
>>>>
>>>> Cc: stable@vger.kernel.org # 3.15+
>>>> Acked-by: Aaron Lu <aaron.lu@intel.com>
>>>> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
>>>> ---
>>>>  drivers/pci/pci.c |   12 +++++++++++-
>>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>> index 625a4ac..53128f0 100644
>>>> --- a/drivers/pci/pci.c
>>>> +++ b/drivers/pci/pci.c
>>>> @@ -2046,7 +2046,17 @@ void pci_pm_init(struct pci_dev *dev)
>>>>         pm_runtime_forbid(&dev->dev);
>>>>         pm_runtime_set_active(&dev->dev);
>>>>         pm_runtime_enable(&dev->dev);
>>>> -       device_enable_async_suspend(&dev->dev);
>>>> +
>>>> +       /*
>>>> +        * The JMicron chip 361/363/368 contains one SATA controller and
>>>> +        * one PATA controller, they are brother-relation ship in PCI tree,
>>>> +        * but for powering on these both controller, we must follow the
>>>> +        * sequence one by one, otherwise one of them can not be powered on
>>>> +        * successfully, so here we disable the async suspend method for
>>>> +        * Jmicron chip.
>>>> +        */
>>>> +       if (dev->vendor != PCI_VENDOR_ID_JMICRON)
>>>> +               device_enable_async_suspend(&dev->dev);
>>>
>>> I don't like littering the core PCI code with vendor tests like this.
>>> This would be the only one, except for an ancient DECchip 21050 bridge
>>> erratum.
>>>
>>> And why would we want a test for *all* JMicron devices here, when you
>>> claim the problem only affects a few specific ones?
>>>
>>> And what's the story with the e6b7e41cdd8c ("ata: Disabling the async
>>> PM for JMicron chip 363/361") connection?  Is something broken even
>>> with e6b7e41cdd8c, and this is a better fix?  Or is this simply a
>>> different way of fixing the same problem?
>>>
>>>>         dev->wakeup_prepared = false;
>>>>
>>>>         dev->pm_cap = 0;
>>>> --
>>>> 1.7.9.5
>>>>
>>>
> 

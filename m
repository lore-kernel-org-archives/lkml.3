Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaKESqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:46:51 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:59977 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaKESqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:46:50 -0500
Message-ID: <545A7087.3050802@laposte.net>
Date: Wed, 05 Nov 2014 19:46:31 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>
CC: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com> <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com>
In-Reply-To: <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrhedvgddviecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefjeenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch solves these 2 bug reports :

https://bugzilla.kernel.org/show_bug.cgi?id=84861

https://bugzilla.kernel.org/show_bug.cgi?id=81551

in simple words : JMicron IDE/Sata controlers family ( JMBxxx ) are not
fully compatible with async_suspend feature, when a user tries to put
his PC on standby mode then at wake-up JMicron IDE/Sata controlers will
not work, because of a brother-relation between the SATA and IDE part on
this JMicron PCI card




Le 05/11/2014 19:01, Bjorn Helgaas a écrit :
> On Tue, Nov 4, 2014 at 6:31 PM, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>> The JMicron chip 361/363/368 contains one SATA controller and
>> one PATA controller, they are brother-relation ship in PCI tree,
>> but for powering on these both controller, we must follow the
>> sequence one by one, otherwise one of them can not be powered on
>> successfully.
> 
> This should mention what's broken and what problem a user would see.
> This changelog sounds a lot like the one for e6b7e41cdd8c, so I don't
> know if this is for a new, related problem, or what.
> 
>> So here we disable the async suspend method for Jmicron chip.
>>
>> Bug link:
>> https://bugzilla.kernel.org/show_bug.cgi?id=81551
>> https://bugzilla.kernel.org/show_bug.cgi?id=84861
>>
>> And we can revert the below commit after this patch is applied:
>> e6b7e41(ata: Disabling the async PM for JMicron chip 363/361)
>>
>> Cc: stable@vger.kernel.org # 3.15+
>> Acked-by: Aaron Lu <aaron.lu@intel.com>
>> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
>> ---
>>  drivers/pci/pci.c |   12 +++++++++++-
>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 625a4ac..53128f0 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -2046,7 +2046,17 @@ void pci_pm_init(struct pci_dev *dev)
>>         pm_runtime_forbid(&dev->dev);
>>         pm_runtime_set_active(&dev->dev);
>>         pm_runtime_enable(&dev->dev);
>> -       device_enable_async_suspend(&dev->dev);
>> +
>> +       /*
>> +        * The JMicron chip 361/363/368 contains one SATA controller and
>> +        * one PATA controller, they are brother-relation ship in PCI tree,
>> +        * but for powering on these both controller, we must follow the
>> +        * sequence one by one, otherwise one of them can not be powered on
>> +        * successfully, so here we disable the async suspend method for
>> +        * Jmicron chip.
>> +        */
>> +       if (dev->vendor != PCI_VENDOR_ID_JMICRON)
>> +               device_enable_async_suspend(&dev->dev);
> 
> I don't like littering the core PCI code with vendor tests like this.
> This would be the only one, except for an ancient DECchip 21050 bridge
> erratum.
> 
> And why would we want a test for *all* JMicron devices here, when you
> claim the problem only affects a few specific ones?
> 
> And what's the story with the e6b7e41cdd8c ("ata: Disabling the async
> PM for JMicron chip 363/361") connection?  Is something broken even
> with e6b7e41cdd8c, and this is a better fix?  Or is this simply a
> different way of fixing the same problem?
> 
>>         dev->wakeup_prepared = false;
>>
>>         dev->pm_cap = 0;
>> --
>> 1.7.9.5
>>
> 

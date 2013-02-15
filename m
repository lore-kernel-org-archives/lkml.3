Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3BOOeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:34:07 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:55591 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3BOOeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130215101640.GN20996@sortiz-mobl>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	<3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	<20130203170213.GQ8476@sortiz-mobl>
	<CAOMFOmW3XdSCJrQJk57-dKNcsyh-B7xcBRKLqpniEd+ROSRvBw@mail.gmail.com>
	<20130215101640.GN20996@sortiz-mobl>
Date: Fri, 15 Feb 2013 06:28:33 -0800
Message-ID: <CAOMFOmWdk=YuF5eF96HrHpiQDU=+pNqiiOWx1kF9iB+gUb1wMA@mail.gmail.com>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        =?UTF-8?B?QWfDs2NzIFDDoWw=?= <agocs.pal.86@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Samuel.


-- replying my message to all
On Fri, Feb 15, 2013 at 2:16 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Anatol,
>
> On Thu, Feb 14, 2013 at 02:48:05PM -0800, Anatol Pomozov wrote:
>> Hi, Aaron
>>
>> On Sun, Feb 3, 2013 at 9:02 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> > Hi Arron,
>> >
>> > On Thu, Jan 24, 2013 at 02:52:39PM -0600, Aaron Sierra wrote:
>> >> In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
>> >> offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
>> >> properly be enabled (and disabled) for these chipsets.
>> >>
>> >> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
>> >> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
>> >> ---
>> >>  drivers/mfd/lpc_ich.c |  109 ++++++++++++++++++++++++++++++++++---------------
>> >>  1 file changed, 76 insertions(+), 33 deletions(-)
>> > I applied this one to my for-next branch, but:
>> >
>> >
>> >> @@ -858,14 +874,35 @@ wdt_done:
>> >>  static int lpc_ich_probe(struct pci_dev *dev,
>> >>                               const struct pci_device_id *id)
>> >>  {
>> >> +     struct lpc_ich_priv *priv;
>> >>       int ret;
>> >>       bool cell_added = false;
>> >>
>> >> -     ret = lpc_ich_init_wdt(dev, id);
>> >> +     priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
>> >> +     if (!priv)
>> >> +             return -ENOMEM;
>> > Could you please come back to me with a follow up patch that would convert
>> > this to the devm_kzalloc() API ?
>>
>> I compiled linux-next (sha == 019f4bc86a462), tried to boot it on my
>> machine and it fails at the very early stage with following oops:
> Would you mind trying the following fix:
>
> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 5c2ef41..fddc8e2 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -916,7 +916,7 @@ static int lpc_ich_probe(struct pci_dev *dev,
>         int ret;
>         bool cell_added = false;
>
> -       priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
> +       priv = kzalloc(sizeof(struct lpc_ich_priv), GFP_KERNEL);
>         if (!priv)
>                 return -ENOMEM;

Yep, it helped. Now I can boot my machine with linux-next (the patch
is tested on Feb 15 tag).

Thanks for the quick fix.

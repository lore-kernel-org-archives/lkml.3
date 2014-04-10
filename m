Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965697AbaDJRzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:55:03 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38796 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbaDJRy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:54:58 -0400
MIME-Version: 1.0
In-Reply-To: <7da0486b-bbdd-445b-8a6d-b5bcb311d908@TX2EHSMHS036.ehs.local>
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
	<CAPDyKFo4R9izP=jcoU+jqd74Nbeh+-5A1T8c_=EL4cmzja_29A@mail.gmail.com>
	<7da0486b-bbdd-445b-8a6d-b5bcb311d908@TX2EHSMHS036.ehs.local>
Date: Thu, 10 Apr 2014 19:54:57 +0200
Message-ID: <CACRpkdbXx4Wpqg1ZiisQnVM7AaDWpA0TjWPD=YnYYBAr2kCrMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] GPIO: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Harini Katakam <harinik@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, michals@xilinx.com,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 9:00 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Mon, 2014-03-31 at 11:23AM +0200, Ulf Hansson wrote:
>> On 27 March 2014 16:25, Harini Katakam <harinik@xilinx.com> wrote:
> [...]
>> > +static int __maybe_unused zynq_gpio_runtime_suspend(struct device *dev)
>> > +{
>> > +       struct platform_device *pdev = to_platform_device(dev);
>> > +       struct zynq_gpio *gpio = platform_get_drvdata(pdev);
>> > +
>> > +       clk_disable(gpio->clk);
>>
>> You should be able can use clk_disable_unprepare() here.
>>
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static int __maybe_unused zynq_gpio_runtime_resume(struct device *dev)
>> > +{
>> > +       struct platform_device *pdev = to_platform_device(dev);
>> > +       struct zynq_gpio *gpio = platform_get_drvdata(pdev);
>> > +
>> > +       return clk_enable(gpio->clk);
>>
>> You should be able can use clk_prepare_enable() here.
>
> Is there some common practice regarding this? As I understand it, we
> want to ensure the clock to be gated during suspend, which should happen
> with clk_disable(). Why would we also unprepare the clock? We are highly
> likely to use it again once we resume.

enable() is fastpath (e.g. in IRQs disabled context) whereas
prepare() is slowpath() in normal, threaded context.

As [runtime]_suspend/resume happens in normal context you
want to make sure clocks are both disabled/unprepared
and prepared/enabled to make sure any clocks that can only
be accessed in slowpath are also turned off/on.

Yours,
Linus Walleij

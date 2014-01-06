Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaAFSwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:52:13 -0500
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:56010 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaAFSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:52:11 -0500
Message-ID: <52CAFB42.1060501@overkiz.com>
Date: Mon, 06 Jan 2014 19:51:46 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/3] usb: ohci-at91: replace request_mem_region + ioremap
 by devm_ioremap_resource
References: <1386579115-4324-1-git-send-email-b.brezillon@overkiz.com>	<1386579115-4324-2-git-send-email-b.brezillon@overkiz.com> <CAOesGMhtg0vqVaRekfCE3-RZL644xEWBn4oVN22DtZR6L5WTxw@mail.gmail.com>
In-Reply-To: <CAOesGMhtg0vqVaRekfCE3-RZL644xEWBn4oVN22DtZR6L5WTxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18114322127244130351
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Olof,

On 06/01/2014 19:08, Olof Johansson wrote:
> Boris,
>
> On Mon, Dec 9, 2013 at 12:51 AM, Boris BREZILLON
> <b.brezillon@overkiz.com> wrote:
>> Replace the request_mem_region + ioremap calls by the
>> devm_ioremap_resource call which does the same things but with device
>> managed resources.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Did you build these patches?

Yes, I did.

> There's several breakages due to them in
> last night's next. I'm a little puzzled how they passed testing before
> you submitted?
> This one fails with:
>
> drivers/usb/host/ohci-at91.c: In function 'usb_hcd_at91_probe':
> drivers/usb/host/ohci-at91.c:157:36: error: 'dev' undeclared (first
> use in this function)
>    hcd->regs = devm_ioremap_resource(dev, res);
>                                      ^
> drivers/usb/host/ohci-at91.c:157:36: note: each undeclared identifier
> is reported only once for each function it appears in
> drivers/usb/host/ohci-at91.c:157:41: error: 'res' undeclared (first
> use in this function)
>    hcd->regs = devm_ioremap_resource(dev, res);

Actually this patch series depends on another patch :
"usb: ohci-at91: fix irq and iomem resource retrieval"
commit fb5f1834c3221e459324c6885eaad75429f722a5.

This patch was taken out to ease integration in 3.13-rc5.

Sorry, I should have stated it in my cover letter.

Which next are you using ?
I took a look at linux-next and the dev variable is declared.

> There are more too, the original one I was bisecting for was the below
> one, but the above hit first:
>
> drivers/usb/host/ohci-at91.c: In function 'usb_hcd_at91_probe':
> drivers/usb/host/ohci-at91.c:190:4: error: label 'err' used but not defined
> drivers/usb/host/ohci-at91.c: At top level:
> drivers/usb/host/ohci-at91.c:206:2: warning: data definition has no
> type or storage class [enabled by default]
> drivers/usb/host/ohci-at91.c:206:2: error: type defaults to 'int' in
> declaration of 'at91_stop_hc' [-Werror=implicit-int]
> drivers/usb/host/ohci-at91.c:206:2: warning: parameter names (without
> types) in function declaration [enabled by default]
> drivers/usb/host/ohci-at91.c:206:2: error: conflicting types for 'at91_stop_hc'
> drivers/usb/host/ohci-at91.c:97:13: note: previous definition of
> 'at91_stop_hc' was here
> drivers/usb/host/ohci-at91.c:208:5: error: expected '=', ',', ';',
> 'asm' or '__attribute__' before ':' token
> drivers/usb/host/ohci-at91.c:210:2: error: expected identifier or '('
> before 'return'
> drivers/usb/host/ohci-at91.c:211:1: error: expected identifier or '('
> before '}' token
> drivers/usb/host/ohci-at91.c:97:13: warning: 'at91_stop_hc' defined
> but not used [-Wunused-function]
>   static void at91_stop_hc(struct platform_device *pdev)

These errors come from merge commit 
99f14bd4d1b2a1b1b6cd508e08efdbc5e3919198.

There is a missing brace on the last retval test.

Best Regards,

Boris
> Somewhat spectacular.  Greg, can you please drop these until he's
> sorted out his submission? :(
>
>
> -Olof


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaIDQqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:46:04 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:32187
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753987AbaIDQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:46:00 -0400
Date: Thu, 4 Sep 2014 09:45:36 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Ezra Savard <ezras@xilinx.com>,
        Ezra Savard <ezra.savard@xilinx.com>
Subject: Re: [PATCH 2/3] gpio: zynq: Fixed broken wakeup implementation
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
 <1409335127-26712-3-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdbb0oeA0b5SSLtR6U7jv8asCeEJdHEsDAg7_tH+GHc5RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbb0oeA0b5SSLtR6U7jv8asCeEJdHEsDAg7_tH+GHc5RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20918.005
X-TM-AS-Result: No--15.598-5.0-31-1
X-imss-scan-details: No--15.598-5.0-31-1
Message-ID: <00af0950-9750-4c5c-97ee-76893823c29d@BN1BFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(189002)(199003)(24454002)(51704005)(377454003)(52604005)(54356999)(76176999)(87936001)(83506001)(74502001)(23676002)(95666004)(74662001)(31966008)(50986999)(85852003)(83072002)(99396002)(85182001)(21056001)(85202003)(106466001)(46102001)(110136001)(92726001)(104016003)(33646002)(85306004)(90102001)(79102001)(74316001)(50466002)(86362001)(92566001)(81542001)(77982001)(81342001)(31696002)(19580405001)(44976005)(6806004)(4396001)(1496007)(83322001)(19580395003)(53416004)(77096002)(80022001)(47776003)(20776003)(76482001)(102836001)(70736001)(64706001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB015;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 06:27PM +0200, Linus Walleij wrote:
> On Fri, Aug 29, 2014 at 7:58 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > From: Ezra Savard <ezra.savard@xilinx.com>
> >
> > Use of unmask/mask in set_wake was an incorrect implementation. The new
> > implementation correctly sets wakeup for the gpio chip's IRQ so the gpio chip
> > will not sleep while wakeup-enabled gpio are in use.
> >
> > Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
> > Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> Patch applied.
> 
> However the problems seems quite generic.
> 
> Do you see this kind of error in other GPIO drivers?
> 
> IRQchip semantics always make me nervous.

Our implementation was just completely flawed. It did work with our
limited tests using the sysfs interface. But once we started with the
gpio_keys things fell apart. The set_wake did mask/unmask IRQs, which
is clearly the job of the respective mask/unmask function of a gpiochip.
After we found that, we looked at a few other drivers and designed this
following gpio-mxs.
So, the core part was to do the right thing in set_wake. Once that was
done, the runtime PM callbacks needed some realignment to determine
whether GPIO is a wakeup device or not.

So, this was really just a gpio-zynq problem, not really generic.

Thanks for applying. I'll post the gpiolib-sysfs patch on its own in a
separate submission.

	Sören

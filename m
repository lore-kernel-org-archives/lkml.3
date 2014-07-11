Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaGKNLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:11:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46389 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaGKNLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:11:30 -0400
Date: Fri, 11 Jul 2014 16:11:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dcb314@hotmail.com
Subject: Re: [PATCH] drivers/staging/comedi/drivers/ni_atmio16d.c: remove
 pointless condition
Message-ID: <20140711131104.GY25880@mwanda>
References: <1405073603-21468-1-git-send-email-andrey.krieger.utkin@gmail.com>
 <53BFD1FF.20309@mev.co.uk>
 <CANZNk82rsdbg+zQGQODmNMpScaHZiZ8MeooGWabWZPGwzErCyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk82rsdbg+zQGQODmNMpScaHZiZ8MeooGWabWZPGwzErCyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:30:15PM +0300, Andrey Utkin wrote:
> 2014-07-11 15:01 GMT+03:00 Ian Abbott <abbotti@mev.co.uk>:
> > On 2014-07-11 11:13, Andrey Utkin wrote:
> >>
> >> The issue was discovered with static analysis and has two instances in
> >> this file. The code looks like this
> >> if (x < 65536000) {
> >>         ...
> >> } else if (x < 655360000) {
> >>         ...
> >> } else if (x <= 0xffffffff /* 6553600000 */) {
> >>         ...
> >> } else if (x <= 0xffffffff /* 65536000000 */) {
> >>         ...
> >> }
> >>
> >> The meaning of this block is to select appropriate clock frequency for
> >> interval timer basing on "x", which is amount of time.
> >>
> >> Notes:
> >> 1. That last condition matches previous one - that's the issue.
> >> 2. Decimal numbers in comments don't match hex numbers in expressions.
> >> But in first case the numbers have same order, while in the second case
> >> the hex number is the same, and the decimal one is 10 times bigger.
> >> 3. Actually type of "x" is "unsigned int", so its exact upper limit is
> >> not obviously known.
> >> 4. There's no "else" block.
> >>
> >> So it makes sense to make an "else" block from last "else if" case. The
> >> code inside the block seems correct for such usage.
> >>
> >> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79871
> >> Reported-by: David Binderman <dcb314@hotmail.com>
> >> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> >> ---
> >>   drivers/staging/comedi/drivers/ni_atmio16d.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c
> >> b/drivers/staging/comedi/drivers/ni_atmio16d.c
> >> index 6ad27f5..895b56d 100644
> >> --- a/drivers/staging/comedi/drivers/ni_atmio16d.c
> >> +++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
> >> @@ -338,7 +338,7 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
> >>         } else if (cmd->convert_arg <= 0xffffffff /* 6553600000 */) {
> >>                 base_clock = CLOCK_10_KHZ;
> >>                 timer = cmd->convert_arg / 100000;
> >> -       } else if (cmd->convert_arg <= 0xffffffff /* 65536000000 */) {
> >> +       } else {
> >>                 base_clock = CLOCK_1_KHZ;
> >>                 timer = cmd->convert_arg / 1000000;
> >>         }
> >
> >
> > Since 0xffffffff is the maximum value 'cmd->convert_arg' can be,
> 
> Could you please substantiate this? I see that convert_arg has type
> "unsigned int" which may be 8 bytes on 64-bit platform.

No.  On linux unsigned int is always 32 bits.

regards,
dan carpenter



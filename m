Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbbAVFZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:25:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49422 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbbAVFZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:25:25 -0500
Date: Thu, 22 Jan 2015 13:22:00 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Doug Anderson <dianders@chromium.org>, <linux@roeck-us.net>
CC: Wim Van Sebroeck <wim@iguana.be>, Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: pat the watchdog before enabling
 it
Message-ID: <20150122132200.4729d38b@xhacker>
In-Reply-To: <1421882243-3631-1-git-send-email-dianders@chromium.org>
References: <1421882243-3631-1-git-send-email-dianders@chromium.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_02:2015-01-22,2015-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501220061
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Doug,

On Wed, 21 Jan 2015 15:17:22 -0800
Doug Anderson <dianders@chromium.org> wrote:

> On some dw_wdt implementations the "top" register may be initted to 0
> at bootup.  In such a case, each "pat" of the watchdog will reset the
> timer to 0xffff.  That's pretty short.

+ Guenter Roeck

This should have been fixed by dfa07141e7a792("watchdog: dw_wdt: initialise
TOP_INIT in dw_wdt_set_top()")

In fact, my original fix is as similar as your patch

http://www.spinics.net/lists/arm-kernel/msg363658.html

Then Guenter Roeck suggest one elegant solution which is the base of
commit dfa07141e7a792.

http://www.spinics.net/lists/arm-kernel/msg363908.html

> 
> The input clock of the wdt can be any of a wide range of values.  On
> an rk3288 system, I've seen the wdt clock be 24.75 MHz.  That means
> each tick is ~40ns and we'll count to 0xffff in ~2.6ms.
> 
> Because of the above two facts, it's a really good idea to pat the
> watchdog after initting the "top" register properly and before
> enabling the watchdog.  If you don't then there's no way we'll get the
> next heartbeat in time.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/watchdog/dw_wdt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> index b34a2e4..fc92bea 100644
> --- a/drivers/watchdog/dw_wdt.c
> +++ b/drivers/watchdog/dw_wdt.c
> @@ -170,6 +170,7 @@ static int dw_wdt_open(struct inode *inode, struct file
> *filp)
>  		 * the maximum and then start it.
>  		 */
>  		dw_wdt_set_top(DW_WDT_MAX_TOP);
> +		dw_wdt_keepalive();
>  		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
>  		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
>  	}


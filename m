Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3KGTkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:40:21 -0500
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:47785 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692Ab3KGTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:40:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2691:2693:2828:2892:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4037:4321:4605:5007:7652:7903:8527:8531:9592:10004:10400:10848:11026:11232:11658:119
X-HE-Tag: veil87_1f1e003ca863e
X-Filterd-Recvd-Size: 3409
Message-ID: <1383853221.9263.14.camel@joe-AO722>
Subject: Re: [PATCH] wcn36xx: Fix logging macro with unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx <wcn36xx@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath5k-devel@venema.h4ckr.net,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>, wil6210@qca.qualcomm.com
Date: Thu, 07 Nov 2013 11:40:21 -0800
In-Reply-To: <CAFSJ42Y-3BZqj+JRNa8wdxjnm1fguD8ToH5Oj0m56yT5NexdVQ@mail.gmail.com>
References: <1383684000.4387.42.camel@joe-AO722>
	 <CAFSJ42YQy96Sko8CuG9BGjHzTV7TkRp2=NVt036APxSKpPB=Ag@mail.gmail.com>
	 <1383760556.7940.28.camel@joe-AO722>
	 <CAFSJ42Y-3BZqj+JRNa8wdxjnm1fguD8ToH5Oj0m56yT5NexdVQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 07:32 +0000, Eugene Krasnikov wrote:
> Hi Joe,

Hi Eugene.

> I personally like the idea of making some kind of framework on top of
> printing because all ath drivers are using the same printing approach
> and combining all that code in one place will reduce amount of code in
> each particular driver. As a true engineer i like when it's less code
> = less work to do = less bugs:)
> 
> Suggestion is to send a patch with semicolon fix only

It's a one line fix, and pretty trivial to do yourself if you
want it.

I do think though the slightly odd wcn36xx_<level> uses of:

-#define wcn36xx_err(fmt, arg...)                               \
-       printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
-
-#define wcn36xx_warn(fmt, arg...)                              \
-       printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
-
-#define wcn36xx_info(fmt, arg...)              \
-       printk(KERN_INFO pr_fmt(fmt), ##arg)
-
[]
+#define wcn36xx_err(fmt, ...)                                  \
+       pr_err("ERROR " fmt, ##__VA_ARGS__)
+#define wcn36xx_warn(fmt, ...)                                 \
+       pr_warn("WARNING " fmt, ##__VA_ARGS__)
+#define wcn36xx_info(fmt, ...)                                 \
+       pr_info(fmt, ##__VA_ARGS__)

should still be converted to more normal pr_<level> like I did.

I don't believe that prefixing of "ERROR " and "WARNING " to
pr_err and pr_warn actually gain anything as the same level
information can be got already with dmesg -r via the "<3>" and
"<4>" prefixes or dmesg -l3 -l4

> have a
> second round of convincing ath guys to change printing code. How does
> that sound?

Luis?  Kalle?  Other Qualcomm/Atheros folk?

One of the nominal benefits of separating the ath_<level>
macros by subsystem was perf/tracing.  I believe some of the
ath subsystems have integrated the dmesg and tracing code.

I'm not sure how separable those may be here or if it's even
desirable to separate them.  I'd guess not.


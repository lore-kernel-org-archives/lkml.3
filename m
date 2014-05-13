Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbaEMIWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:22:55 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:38984 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaEMIWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
Date: Tue, 13 May 2014 13:52:51 +0530
Message-ID: <CAKohpo=6qXer+RRS-F6x=O1VLzbWq+_a-b29MaUzZBvt7XzDwQ@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "[Chander Kashyap" <chander.kashyap@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2014 13:11, [Chander Kashyap <chander.kashyap@linaro.org> wrote:

What happened to your name ? "["

> From: Chander Kashyap <k.chander@samsung.com>
>
> It may be possible to unregister and re-register the cpufreq driver.
> One such example is arm big-little IKS cpufreq driver. While
> re-registering the driver, same OPPs may get added again.
>
> This patch detects the duplicacy and discards them.
>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
>  drivers/base/power/opp.c |   28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)

I wouldn't say that this approach is particularly bad or wrong, but what
about this instead?

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..7efdaf3 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -713,6 +713,11 @@ int of_init_opp_table(struct device *dev)
        const __be32 *val;
        int nr;

+       if (!IS_ERR(find_device_opp(dev))) {
+               dev_warn("%s: opp table already exists\n", __func__);
+               return -EEXIST;
+       }
+
        prop = of_find_property(dev->of_node, "operating-points", NULL);
        if (!prop)
                return -ENODEV;

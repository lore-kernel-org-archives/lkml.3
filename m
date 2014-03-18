Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaCRFnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:43:11 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37740 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaCRFnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <3229882.l5W5UxujLO@vostro.rjw.lan>
References: <16035918.jZXKnQ3yiq@vostro.rjw.lan>
	<1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com>
	<1394831037-15553-2-git-send-email-dirk.j.brandewie@intel.com>
	<3229882.l5W5UxujLO@vostro.rjw.lan>
Date: Tue, 18 Mar 2014 11:13:08 +0530
X-Google-Sender-Auth: UNCHBEnLtAnIBHqzqqY0xFUaaLE
Message-ID: <CAOh2x=nDBrofobgHokDxqpkpfSBPB-a32TE10WZQLYaqq4QGTw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cpufreq: Add exit_prepare callback to
 cpufreq_driver interface
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 7:34 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, March 14, 2014 02:03:56 PM dirk.brandewie@gmail.com wrote:

>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1338,6 +1338,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>>               }
>>       }
>>
>> +     if (cpufreq_driver->stop)
>
> What about doing
>
> +       if (cpufreq_driver->setpolicy && cpufreq_driver->stop)
>
> here instead?  That would make it clear where the new callback belongs.

This is called after stopping governor and so might be useful for ->target()
drivers. So, wouldn't be a bad option if we keep it available for all..

@Dirk: I thought about the solution I mentioned in another mail. And it looks
like I will end up getting a similar solution. So, we will go with
your solution.

Just few changes for your solution..

You need to call ->stop() only for the last CPU of every policy and not for
every CPU, so you need something like this:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 19d25a8..78d41c0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1371,6 +1371,8 @@ static int __cpufreq_remove_dev_prepare(struct
device *dev,
                                         __func__, new_cpu, cpu);
                        }
                }
+       } else if (cpufreq_driver->stop) {
+               cpufreq_driver->stop(policy);
        }

        return 0;

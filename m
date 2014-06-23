Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaFWWT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:19:26 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34727 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaFWWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:19:14 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c\@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
	<7hwqcbs166.fsf@paris.lan>
	<CAD=FV=Uz9O0i2gmuk2+BHa-Tksvyxv0+MTi2UEjVREAMNCK7Ug@mail.gmail.com>
	<7h7g4brx6w.fsf@paris.lan>
	<CAD=FV=VmPMf6tCNmKJ1o5J7PyAXoU8fb6+s+Fkv18FH2WaQp7A@mail.gmail.com>
	<53A4CADA.4030002@gmail.com>
	<CAD=FV=VkxA01eEFiXSp+c+GDuVJi7TctAdnyrMggk1gRw6BStQ@mail.gmail.com>
Date: Mon, 23 Jun 2014 15:19:11 -0700
In-Reply-To: <CAD=FV=VkxA01eEFiXSp+c+GDuVJi7TctAdnyrMggk1gRw6BStQ@mail.gmail.com>
	(Doug Anderson's message of "Mon, 23 Jun 2014 15:01:39 -0700")
Message-ID: <7ha993p8v4.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

[...]

> On Fri, Jun 20, 2014 at 4:59 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>
>> I'm not sure noirq is going to work correctly, at least not with current
>> callbacks. I can see a call to clk_prepare_enable() there which needs to
>> acquire a mutex.
>
> Nice catch, thanks!  :)
>
> OK, looking at that now.  Interestingly this doesn't seem to cause us
> problems in our ChromeOS 3.8 tree.  I just tried enabling:
>   CONFIG_DEBUG_ATOMIC_SLEEP=y
>
> ...and confirmed that I got it on right:
>
> # zgrep -i atomic /proc/config.gz
> CONFIG_DEBUG_ATOMIC_SLEEP=y
>
> I can suspend/resume with no problems.  My bet is that it works fine because:
>
> * resume_noirq is not considered "atomic" in the sense enforced by
> CONFIG_DEBUG_ATOMIC_SLEEP (at least not in 3.8--I haven't tried on
> ToT)

The reason is because "noirq" in the suspend/resume path actually means
no *device* IRQs for that specific device.

It's often assumed that the "noirq" callbacks are called with *all*
interrupts disabled, but that's not the case.  Only the IRQs for that
specific device are disabled when its noirq callbacks run.

Kevin

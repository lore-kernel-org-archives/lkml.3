Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaFDFqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 01:46:40 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64120 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaFDFqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 01:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140603154854.GG31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
	<20140527192923.GC12304@sirena.org.uk>
	<CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
	<20140528173858.GG5099@sirena.org.uk>
	<CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
	<20140603145347.GE31751@sirena.org.uk>
	<CAKohpo=VLCf2nz1WsL-iGw6BWwpmqZ+8JwGFFHFFtjZyAS9LrA@mail.gmail.com>
	<20140603154854.GG31751@sirena.org.uk>
Date: Wed, 4 Jun 2014 11:16:37 +0530
Message-ID: <CAKohpon9G=JdZ1jSStHZH29VZDggZXm+EOqDAwedk2K0ZxD0Qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulators: Add definition of regulator_set_voltage_time()
 for !CONFIG_REGULATOR
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 21:18, Mark Brown <broonie@kernel.org> wrote:
> No, as I've explained repeatedly NULL is a perfectly valid regulator and

Okay, its been checked at multiple places already and that's obviously
wrong then.

> that's not going to work reliably.  As I've previously requested please
> think about what happens to cpufreq if we fail to ramp voltages.

Okay, so here is the scenario:

- driver is generic (like cpufreq-cpu0) and some user platforms may have
regulator support and others might not..

- For platforms with regulators support, we _must_ check if the voltage
change is successful or not and fail if regulator_set_voltage() failed.

- But for platforms without regulators support (CONFIG_REGULATOR=n),
regulator_get() will return NULL (a valid regulator though) and
regulator_set_voltage() will fail. Because the platform doesn't care much
about regulators it must go on and change frequency as if nothing
happened.

How can we achieve both these requirements by a generic piece of
code?

The only way I could think of currently is by returning something
special like -ENOSYS from regulator_set_voltage() when
regulators aren't configured in kernel and check return value of
regulator_set_voltage() against this..

This also holds true for regulator_get_voltage() which is returning
-EINVAL currently..

Please share if you have some other solution in mind..

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3FRBbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:31:03 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:60776 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3FRBbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:31:00 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-c3-51bfb853f141
From: Shuah Khan <shuah.kh@samsung.com>
To: "rjw@sisk.pl" <rjw@sisk.pl>, "a.zummo@towertech.it" <a.zummo@towertech.it>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: pm: System date and time set incorrectly after suspend/resume to disk
Thread-topic: System date and time set incorrectly after suspend/resume to disk
Thread-index: Ac5rw3sM8UdraAXMS3+tGCDERgjo2A==
Date: Tue, 18 Jun 2013 01:30:57 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172A070@sisaex02sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+wn27wjv2BBlfOilksuXiV3eLyrjls
	Fp97jzBa9C/sZbLY39nBaPH1p4MDm8fOWXfZPfZMPMnm8WhxC6PH9Hk/mTw+b5ILYI3isklJ
	zcksSy3St0vgyth8eDF7wXO+isX3+BsY23m6GDk5JARMJB5POcsEYYtJXLi3nq2LkYtDSGAZ
	o8Tms5dZQBJCAr1MEhfOyEEk5jNKzP73ghEkwSagLvH59Q52EFtEwE9i3aNbjCBFzAKdQA3v
	P7KBJISBEgtX/mKDKPKXmDvvM5StJ3H26GKw1SwCqhK7T88GG8orYC8x48x9sM2MQCd9P7UG
	rIZZQFyiufUmC8SpAhJL9pxnhrBFJV4+/sfaxcgBZCtKbF9tBVGuJbF+53GoVm2JJ+8usEKM
	F5T4MfkeywRG0VlIps5C0jILScssJC0LGFlWMYqVFicXFCelp1YY6hUn5haX5qXrJefnbmKE
	xFrVDsY7X20OMQpwMCrx8HKI7A8UYk0sK67MPcQowcGsJMIbO3FfoBBvSmJlVWpRfnxRaU5q
	8SFGJg5OqQZGt+uP3z6/+qL5c3/X/mjZ2KNt29f8aS45yaSYV5Ehm61g6b/xmcfSYrlP5+ff
	6Fap9VyscJLj+aGVk46tWx94/nn2loR27oeyLP4Fu9muKDP6LTSTMlot3FfamC29ulmQ3YS/
	4kTZXDGjWzGd18oKLjRquR+JTbjv5TDPZN9+B8Ydwu8dNEuUWIozEg21mIuKEwHtGCk9kwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing a problem on my system after a suspend to disk in reboot or 
shutdown mode. When pm_trace is 0 (which is the default), I can't 
reproduce the problem easily. I have to run a few more suspend tests 
before I see the problem. When pm_trace is disabled, the problem showed 
up when I ran suspend in platform mode in a row. However when pm_ptrace 
is enabled, problem happens on the very first spend to disk in reboot mode.

Steps to run into the issue:

echo 1 > pm_print_times
echo 1 > pm_trace
echo reboot > disk
echo disk > state

or

echo 1 > pm_print_times
echo 1 > pm_trace
echo shutdown > disk
echo disk > state

When system comes back up, system time set to incorrect time.

In this latest round of testing:

time before suspend was Mon Jun 17 16:27 MDT 2013
right after resume was Thu Oct 5 18:24:42 MDT 2028

I have NTP enabled on my system and I have to disable/re-enable NTP from 
Time and Date config menu.

rtc class suspend routine rtc_suspend() does adjustments to account for 
the time spent suspended. Is that the right one run in this case?

rtc_suspend() doesn't run because has_persistent_clock() returns true. 
rtc-cmos pnp driver suspend routines runs.

It is a possible race condition that is triggered when the conditions 
are right.

I have the following enabled in my config

CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"

Looking for tips on debugging the problem.

thanks,
-- Shuah
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab3HSUPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:15:04 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:10475 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3HSUPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:15:02 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTzPnNKX9X
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [ 00/34] 3.4.59-stable review
Date: Mon, 19 Aug 2013 22:14:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-6.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20130818203259.653403173@linuxfoundation.org> <52125DA9.3090601@samsung.com> <20130819193538.GB24897@kroah.com>
In-Reply-To: <20130819193538.GB24897@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308192214.54917.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Monday 19 August 2013, Greg Kroah-Hartman wrote:
> On Mon, Aug 19, 2013 at 12:02:17PM -0600, Shuah Khan wrote:
> > On 08/18/2013 02:34 PM, Greg Kroah-Hartman wrote:
[…] 
> > and the following traces in dmesg:
> > [  124.802169] init: udevtrigger post-stop process (353) terminated
> > with status 1
> > [  243.439212] INFO: task crda:723 blocked for more than 120 seconds.
> 
> What is "crda"?
> 
> Any luck with bisection?  It should go fast as the majority of patches
> here are non-x86.

crda is a userspace helper, invoked by udev events, which sets -and
intersects as needed- the regulatory domain settings for (modern, 
cfg80211 based) wlan hardware based on the device's EEPROM regdom hint,
local configuration (country code) and eventual IEEE 802.11d hints 
(country IEs) beaconed by access points nearby. It hooks into udev with
these udev rules (Debian/ 1.1.2-1):

$ grep -v -e ^$ -e ^\# /lib/udev/rules.d/60-crda.rules 
SUBSYSTEM=="ieee80211", ACTION=="add", RUN+="/lib/crda/setregdomain"

$ grep -v -e ^$ -e ^\# /lib/udev/rules.d/85-regulatory.rules 
KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform", RUN+="/sbin/crda"

Full source is at [2], it should be installed on pretty much every 
distro/ system released with wlan support for the last >>3 years.

There are two iwl4965 patches in this series, which might be among the
first ones to check - /if/ you actually have that hardware, the second
one (iwl4965: reset firmware after rfkill off) might also indirectly 
have an effect on blutetooth (via rfkill).

Regards
	Stefan Lippers-Hollmann

[1]	http://wireless.kernel.org/en/developers/Regulatory/CRDA
[2]	https://github.com/mcgrof/crda

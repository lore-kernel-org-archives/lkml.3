Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab3FRS1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:27:21 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59197 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab3FRS1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:27:20 -0400
Message-ID: <51C0A684.8030405@message-id.googlemail.com>
Date: Tue, 18 Jun 2013 20:27:16 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
References: <51ACD4B2.7070107@message-id.googlemail.com> <51ACD600.2020805@message-id.googlemail.com> <CA+i0qc4eEDjygde4+frqd51JutTDeoJ8mTp-K==gwG_7ghJwcw@mail.gmail.com>
In-Reply-To: <CA+i0qc4eEDjygde4+frqd51JutTDeoJ8mTp-K==gwG_7ghJwcw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

executive summary: it is not fixed in 3.10rc6

Am 03.06.2013 20:09, schrieb Tomas Winkler:
>>> Or, to be more precise: it breaks resume.
>>>
>>> The machine seems to lock up hard after resume, then after a few seconds
>>> it panics (caps lock blinking).
>>>
>>> Reproduced on ThinkPad X200s
>>>
>>> 00:03.0 0780: 8086:2a44 (rev 07)
>>> Intel Corporation Mobile 4 Series Chipset MEI Controller
>>>
>>> Debugged with "init=/bin/bash no_console_suspend", I see lots of errors
>>> from the mei_me driver, then finally the panic (some overflow maybe?).
>>>
>>> Unbinding the device before suspend fixes resume.
>>
>> I just noticed that I get the following message on unbinding:
>>
>> $ echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/unbind
>> $ dmesg|tail -2
>> [ 1216.830034] mei_me 0000:00:03.0: stop
>> [ 1216.837018] mei_me 0000:00:03.0: wait hw ready failed. status = 0x0
>>
>> not sure if this is related.
>>
> Thanks for the report I'm looking into it.

I looked at the git log of drivers/misc/mei and it looked promising.

However, it still does not work, commit
42f132febff3b7b42c6c9dbfc151f29233be3132 does not seem to help enough on
my hardware.

Still just unbinding and rebinding with
echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/unbind
echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/bind

triggers lots of
[  318.330981] mei_me 0000:00:03.0: reset: wrong host start response
[  318.330984] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
[  318.330990] mei_me 0000:00:03.0: reset: unexpected enumeration response hbm.
[  318.330993] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
[  318.331016] mei_me 0000:00:03.0: reset: wrong host start response
[  318.331019] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
[  346.571031] mei_me 0000:00:03.0: reset: init clients timeout hbm_state = 1.
[  346.571047] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
[  376.631030] mei_me 0000:00:03.0: reset: init clients timeout hbm_state = 1.
[  376.631044] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING

It does, however, calm down after a few seconds, only to spew a few lines
once every 30 seconds:

[  406.691032] mei_me 0000:00:03.0: reset: init clients timeout hbm_state = 1.
[  406.691048] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
[  436.751033] mei_me 0000:00:03.0: reset: init clients timeout hbm_state = 1.
[  436.751047] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
[  466.811030] mei_me 0000:00:03.0: reset: init clients timeout hbm_state = 1.
[  466.811044] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING

So it is not yet fixed, unfortunately.

Best regards,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537

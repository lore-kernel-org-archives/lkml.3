Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaFXQet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:34:49 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:43152
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755785AbaFXQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:34:25 -0400
Message-ID: <53A9A88B.2000006@chelsio.com>
Date: Tue, 24 Jun 2014 09:34:19 -0700
From: Casey Leedom <leedom@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hariprasad@chelsio.com,
        poswald@suse.com, santosh@chelsio.com, jcheung@suse.com,
        dchang@suse.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT 0/3] cxgb4: use request_firmware_nowait()
References: <1403311181-9328-1-git-send-email-mcgrof@do-not-panic.com> <53A87AC8.7010305@chelsio.com> <20140624002941.GD27687@wotan.suse.de> <53A99F71.2060308@chelsio.com>
In-Reply-To: <53A99F71.2060308@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/24/14 08:55, Casey Leedom wrote:
>
> On 06/23/14 17:29, Luis R. Rodriguez wrote:
>> On Mon, Jun 23, 2014 at 12:06:48PM -0700, Casey Leedom wrote:
>>
>>> Also, it might be useful if there was a way for the driver
>>> module to "tell" the timeout mechanism that forward progress _is_ being
>>> made so it doesn't blow away the driver module load.
>> Indeed if this is actually needed, but believe the issue here for the
>> huge delays might be instead the lack of not using 
>> request_firmware_direct()
>> and actual device initialization time, which I do not believe we 
>> penalize,
>> we should be penalizing only the amount of time it takes either the
>> kernel or udev to read the firmware from the filesystem.
>
>   If you want I can time the actual phases of loading new firmware: 
> request_firmware(), writing it to FLASH, release_firmware() ...

   So I just did this for a normal modprobe (after the system is up):

Jiffies    Process
-----------------------------------------------------------------------
       0    begin firmware load process
       3    request_firmware() returns
       7    start looking at the adapter
      10    finish reading the first sector of existing adapter firmware
      26    we've decided that we're going to upgrade the firmware
      28    actual firmware upgrade process starts
     448    we've finished halting the adapter processor
     451    we enter the firmware write routine
   8,470    we've finished erasing the firmware FLASH sectors
  14,336    write of new firmware is complete
  14,340    the new firmware load is complete
  14,949    the adapter processor has been restarted; new firmware running
  14,952    firmware upgrade process complete

Maybe request_firmware() takes more time during the boot phase but as we 
can see from the above timings, it's the actual firmware upgrade process 
which takes the most time ...

Casey

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab3CYSqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:46:31 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:33176 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3CYSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:46:30 -0400
Message-ID: <51509B84.2050106@monom.org>
Date: Mon, 25 Mar 2013 19:46:28 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: ALSA regression Macbook Air 5,2: No sound from the loudspeaker
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experience a regression on my Macbook Air 2012 model with the 3.9-rc 
kernels (v3.9-rc2-284-gaea8b5d) The symptoms are that there is just no 
sound from the loudspeakers. The headphone output works fine.

I was able to pin point it down to one commit

1077a024 "ALSA: hda - Use generic parser for Cirrus codec"

If I revert this one and all came back to work. By comparing the 
alsa-info.txt output I figured that there is something wrong with the 
GPIO settings on node 0x01:

This is the excerpt with the previous patch mentioned reverted:


Codec: Cirrus Logic CS4206
Address: 0
AFG Function Id: 0x1 (unsol 0)
Vendor Id: 0x10134206
Subsystem Id: 0x106b5600
Revision Id: 0x100302
No Modem Function Group found
Default PCM:
     rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
     bits [0x1e]: 16 20 24 32
     formats [0x3]: PCM FLOAT
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
State of AFG node 0x01:
   Power states:  D0 D3 CLKSTOP EPSS
   Power: setting=D0, actual=D0
GPIO: io=4, o=0, i=0, unsolicited=0, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[1]: enable=1, dir=1, wake=0, sticky=0, data=0, unsol=0
   IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[3]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0


and here the output vanilla kernel:


Codec: Cirrus Logic CS4206
Address: 0
AFG Function Id: 0x1 (unsol 0)
Vendor Id: 0x10134206
Subsystem Id: 0x106b5600
Revision Id: 0x100302
No Modem Function Group found
Default PCM:
     rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
     bits [0x1e]: 16 20 24 32
     formats [0x3]: PCM FLOAT
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
State of AFG node 0x01:
   Power states:  D0 D3 CLKSTOP EPSS
   Power: setting=D0, actual=D0
GPIO: io=4, o=0, i=0, unsolicited=0, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[1]: enable=1, dir=1, wake=0, sticky=0, data=0, unsol=0
   IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[3]: enable=1, dir=1, wake=0, sticky=0, data=0, unsol=0


The diff is "IO[3] data=1 vs data=0". I used then the patch function 
from the awesome hda-analyzer tool to patch this on the vanilla kernel 
and there suddenly I have output from the speakers.

I don't know if someone else has reported this already or if there is 
already a fix. I was without internet for few days and didn't report 
this in time. If that is the case, sorry for the noise.


The complete logs from hda-analyzer are here:

http://www.monom.org/misc/alsa/alsa-info.txt-v3.9-rc2-284-gaea8b5d
http://www.monom.org/misc/alsa/alsa-info.txt-revert-1077a024


cheers,
daniel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab3ANWcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:32:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53776 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409Ab3ANWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:32:30 -0500
Message-ID: <50F4877B.2090409@wwwdotorg.org>
Date: Mon, 14 Jan 2013 15:32:27 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org> <50F134C9.1040203@nvidia.com> <50F4820C.2050806@wwwdotorg.org>
In-Reply-To: <50F4820C.2050806@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 03:09 PM, Stephen Warren wrote:
> On 01/12/2013 03:02 AM, Laxman Dewangan wrote:
>> On Saturday 12 January 2013 04:39 AM, Stephen Warren wrote:
>>> On 01/11/2013 06:33 AM, Laxman Dewangan wrote:
>>>> Enable tegra based keyboard controller and populate the key matrix for
>>>> seaboard. The key matrix was originally on driver code which is removed
>>>> to have clean driver. The key mapping is now passed through dts file.
>>>>
>>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>>> ---
>>>> Requesting for testing on seaboard.
>>>> I generated this patch as Stephen suggested to have one patch for dt
>>>> file
>>>> entry for keys on seaboard.
>>
>> Thanks for testing.

>>> Once I hacked around the above issues, the driver doesn't work very well
>>> at all. There is a *long* delay between when I press a key and when it
>>> shows up (e.g. echo'd to the HDMI console). When I release the key the
>>> same keypress is generated twice. Or perhaps it's a repeat, but since
>>> it's *always* 2 extra keypresses and I doubt I always hold my finger on
>>> the key the exact same amount of time, I think it's key release that
>>> does this not repeat. I assume this would repro on any board, so you
>>> won't need Seaboard to debug it. Harmony is able to read the keyboard
>>> using the KBC.
>>>
>>> Even with the above, I was able to validate that the keymap in the
>>> Seaboard .dts file looks reasonable.
>>>
>>> However, please fix the KBC driver...
>>
>> I did not see any issue with the 3x3 matrix. I think all these about is
>> to tuning debaunce and other parameter also. Another thing is that to
>> make sure that all pinmuxes are properly configured.
> 
> OK, I'll go look at some downstream kernels for Seaboard and see if the
> debounce etc. parameters all match up.

How odd. The problems were indeed solved by using the downstream
debounce/... timings. It's odd that using a shorter debounce time leads
to /not/ generating spurious keypress events; perhaps the HW is buggy
for the extremely large debounce value that you chose.

I also noticed that one entry in the keymap had a typo.

Can you please roll the patch below into yours:

diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts
b/arch/arm/boot/dts/tegra20-seaboard.dts
index b22522d..2e87330 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -614,8 +614,9 @@

        kbc {
                status = "okay";
-               nvidia,debounce-delay-ms = <640>;
-               nvidia,repeat-delay-ms = <1>;
+               nvidia,debounce-delay-ms = <32>;
+               nvidia,repeat-delay-ms = <160>;
+               nvidia,ghost-filter;
                nvidia,kbc-row-pins = <0 1 2 3 4 5 6 7 8 9 10 11 12 13
14 15>;
                nvidia,kbc-col-pins = <16 17 18 19 20 21 22 23>;
                linux,keymap = <0x00020011      /* KEY_W */
@@ -672,7 +673,7 @@
                                0x0805002A      /* KEY_LEFTSHIFT */

                                0x09050061      /* KEY_RIGHTCTRL */
-                               0x0907001B      /* KEY_LEFTCTRL */
+                               0x0907001D      /* KEY_LEFTCTRL */

                                0x0B00001A      /* KEY_LEFTBRACE */
                                0x0B010019      /* KEY_P */


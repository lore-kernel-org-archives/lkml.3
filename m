Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaCWLvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 07:51:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39491 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaCWLvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 07:51:13 -0400
Message-ID: <532ECAA7.3020508@linux.com>
Date: Sun, 23 Mar 2014 12:51:03 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?VGVvZG9yYSBCxINsdcWjxIM=?= <teobaluta@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>	<20140319201838.GA11403@redhat.com>	<CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>	<20140321132816.GW15608@titan.lakedaemon.net>	<532DC3D3.9060008@linux.com> <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com> <532DD68B.3010302@linux.com>
In-Reply-To: <532DD68B.3010302@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/22/2014 07:29 PM, Levente Kurusa wrote:
> Hi,
> 
> On 03/22/2014 07:20 PM, Teodora Băluţă wrote:
>> On Sat, Mar 22, 2014 at 7:09 PM, Levente Kurusa <levex@linux.com> wrote:
>>> Hi,
>>>
>>> On 03/21/2014 02:28 PM, Jason Cooper wrote:
>>>> On Wed, Mar 19, 2014 at 10:38:30PM +0200, Teodora Băluţă wrote:
>>>>> On Wed, Mar 19, 2014 at 10:18 PM, Dave Jones <davej@redhat.com> wrote:
>>>>>> On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
>>>>>>  > This feature encodes Oops messages into a QR barcode that is scannable by
>>>>>>  > any device with a camera.
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>> That's a ton of code we're adding into one of the most fragile parts of the kernel.
>>>>>>
>>>>>> A lot of what libqrencode does would seem to be superfluous to the requirements
>>>>>> here, as we don't output kernel oopses in kanji for eg, and won't care about
>>>>>> multiple versions of the qr spec.
>>>>>
>>>>> That's true. I didn't do that much cleanup in the library afraid of
>>>>> breaking something and focused that I get this done one way or
>>>>> another. Indeed, the library is userspace and is made to be versatile
>>>>> rather than small.
>>>>
>>>> Perhaps you could add libqr to the staging tree?  As long as it
>>>> compiles, it can go there.  Then you can focus on cleanups and bloat
>>>> removal.  In the process, you'll get a larger testing base because it
>>>> will be in mainline.
>>>
>>> Yea that is a better way. However, the current state of the code has
>>> several problems:
>>>
>>> * No good error handling (simply returns -1 on failure no matter what)
>>>    I have began converting this to the ERR_PTR et al interface
>>>    However, I have not yet done this fully due to the vast amount
>>>    of work required to do so.
>>>    This shouldn't be yet merged, but I shall send it as patches once
>>>    it gets into the staging tree.
>>>
>>> * All memory allocations are GFP_ATOMIC for no reason.
>>>    I have converted them to GFP_KERNEL since we can block safely.
>>>    This could be merged to Teodora's branch. I can send her a pull
>>>    request on GitHub if she wants so.
>>
>> Since we are talking about some kernel Oopses I thought that making
>> this GFP_ATOMIC ensures that we get memory allocation. I have
>> considered using GFP_KERNEL, but I am not very sure about that.
>> Probably somewhere deep inside I wanted to make it work even for
>> panics. :(
> 
> Yea that makes sense, realized that just after I sent the mail.
> However, since this is in lib/ other parts might want to be
> able to use it and for them GFP_KERNEL makes more sense.

In order to make libqr usable in other parts of the kernel,
we need to heavily restructure libqr. It seems to use a style
that was inherited from OOP. Since we are in C, I don't like it.
I think that the allocations for the structs (e.g. QRinput) should
be done by the caller. That way we could remove most of the
allocations from libqr, and the rest may use GFP_KERNEL if they
still exist after that cleanup. Any objections?

>>>
>>> [...] 
>>>
>>> * I had trouble getting QR output.
>>>    Doing 'echo c > /proc/sysrq-trigger' triggered a crash,
>>>    but it resulted in a recursive OOPS. This is a nullptr-deref
>>>    and hence I think it may be related to the fact I was running
>>>    it in textmode. :-)
>>>    Or, it is due to the bugged error handling.
>>
>> The QR output is written to the frame buffer. That means you have to
>> get acces to a console. As I mentioned in the RFC, I am looking for an
>> alternative to using fb.h since that doesn't seem to work very well
>> atm.

Okay, I sent you a pull request that fixes a recursive OOPS when crashing
in textmode and no higher mode is available. Patch attached as well [0].

Also, have you check ASCII characters 219-223? Maybe they are usable?
Any ideas?

[0]:

----------------%<---------------------
From: Levente Kurusa <levex@linux.com>
Subject: [PATCH] qr: print_oops: don't try to print if there is no framebuffer

If the kernel boots in textmode, we would hit a null pointer derefernce
in compute_w(). Prevent this by actually checking the value of info.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 kernel/print_oops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/print_oops.c b/kernel/print_oops.c
index f43c059..f8909ba 100644
--- a/kernel/print_oops.c
+++ b/kernel/print_oops.c
@@ -126,6 +126,10 @@ void print_qr_err(void)
 	qr = QRcode_encodeData(compr_len, compr_qr_buffer, 0, QR_ECLEVEL_H);

 	info = registered_fb[0];
+	if (!info) {
+		printk(KERN_WARNING "Unable to get hand of a framebuffer!\n");
+		goto exit;
+	}
 	w = compute_w(info, qr->width);

 	rect.width = w;
@@ -167,6 +171,7 @@ void print_qr_err(void)
 		}
 	}

+exit:
 	QRcode_free(qr);
 	qr_compr_exit();
 	buf_pos = 0;
-- 
1.8.3.1
----------------%<---------------------

-- 
Regards,
Levente Kurusa

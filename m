Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaCVRJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:09:49 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61920 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaCVRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:09:47 -0400
Message-ID: <532DC3D3.9060008@linux.com>
Date: Sat, 22 Mar 2014 18:09:39 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        =?UTF-8?B?VGVvZG9yYSBCxINsdcWjxIM=?= <teobaluta@gmail.com>
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com> <20140319201838.GA11403@redhat.com> <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com> <20140321132816.GW15608@titan.lakedaemon.net>
In-Reply-To: <20140321132816.GW15608@titan.lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/21/2014 02:28 PM, Jason Cooper wrote:
> On Wed, Mar 19, 2014 at 10:38:30PM +0200, Teodora Băluţă wrote:
>> On Wed, Mar 19, 2014 at 10:18 PM, Dave Jones <davej@redhat.com> wrote:
>>> On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
>>>  > This feature encodes Oops messages into a QR barcode that is scannable by
>>>  > any device with a camera.
>>>
>>> [...]
>>>
>>> That's a ton of code we're adding into one of the most fragile parts of the kernel.
>>>
>>> A lot of what libqrencode does would seem to be superfluous to the requirements
>>> here, as we don't output kernel oopses in kanji for eg, and won't care about
>>> multiple versions of the qr spec.
>>
>> That's true. I didn't do that much cleanup in the library afraid of
>> breaking something and focused that I get this done one way or
>> another. Indeed, the library is userspace and is made to be versatile
>> rather than small.
> 
> Perhaps you could add libqr to the staging tree?  As long as it
> compiles, it can go there.  Then you can focus on cleanups and bloat
> removal.  In the process, you'll get a larger testing base because it
> will be in mainline.

Yea that is a better way. However, the current state of the code has
several problems:

* No good error handling (simply returns -1 on failure no matter what)
   I have began converting this to the ERR_PTR et al interface
   However, I have not yet done this fully due to the vast amount
   of work required to do so.
   This shouldn't be yet merged, but I shall send it as patches once
   it gets into the staging tree.

* All memory allocations are GFP_ATOMIC for no reason.
   I have converted them to GFP_KERNEL since we can block safely.
   This could be merged to Teodora's branch. I can send her a pull
   request on GitHub if she wants so.

* Selecting QR_OOPS and QRLIB currently does not build due to
   undefined references to zlib_deflate* functions.
   This is due to QRLIB not selecting ZLIB_DEFLATE.
   Fixed this as well. Can be merged to Teodora if she wants.

* I had trouble getting QR output.
   Doing 'echo c > /proc/sysrq-trigger' triggered a crash,
   but it resulted in a recursive OOPS. This is a nullptr-deref
   and hence I think it may be related to the fact I was running
   it in textmode. :-)
   Or, it is due to the bugged error handling.

> 
> You may be interested in objdiff [1] which I'm using for merging code
> into the staging tree [2].  It provides an automated way to determine
> that code cleanups didn't change the resultant object code.  You can see
> an example run here [3].
> 
> I would definitely like to see the QR output incorporated into a
> kernel.org url.  That would remove the need for installing another app,
> and would ease bug reporting.

I still struggle to understand how could that be done. We can encode the
QR code as ASCII. Okay, that's fine, however it is very long. Encoding
'Unable to handle kernel paging request at 0000000f' gave a 449 character
long sequence with very strange characters [0]. We should try to shorten
it, imho. Not sure how to do that though.

oops.kernel.org/?qr=CODE  would look cool though. :-)

> 
> Anyway, if you're interested, I'll be re-posting a patch for objdiff
> separately maybe today or this weekend.


[0]: http://paste.fedoraproject.org/87665/39550664/


-- 
Regards,
Levente Kurusa

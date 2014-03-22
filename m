Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaCVSUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:20:05 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:57837 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVSUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <532DC3D3.9060008@linux.com>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
	<20140319201838.GA11403@redhat.com>
	<CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
	<20140321132816.GW15608@titan.lakedaemon.net>
	<532DC3D3.9060008@linux.com>
Date: Sat, 22 Mar 2014 20:20:01 +0200
Message-ID: <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: =?ISO-8859-2?B?VGVvZG9yYSBC42x1/uM=?= <teobaluta@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 7:09 PM, Levente Kurusa <levex@linux.com> wrote:
> Hi,
>
> On 03/21/2014 02:28 PM, Jason Cooper wrote:
>> On Wed, Mar 19, 2014 at 10:38:30PM +0200, Teodora Băluţă wrote:
>>> On Wed, Mar 19, 2014 at 10:18 PM, Dave Jones <davej@redhat.com> wrote:
>>>> On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
>>>>  > This feature encodes Oops messages into a QR barcode that is scannable by
>>>>  > any device with a camera.
>>>>
>>>> [...]
>>>>
>>>> That's a ton of code we're adding into one of the most fragile parts of the kernel.
>>>>
>>>> A lot of what libqrencode does would seem to be superfluous to the requirements
>>>> here, as we don't output kernel oopses in kanji for eg, and won't care about
>>>> multiple versions of the qr spec.
>>>
>>> That's true. I didn't do that much cleanup in the library afraid of
>>> breaking something and focused that I get this done one way or
>>> another. Indeed, the library is userspace and is made to be versatile
>>> rather than small.
>>
>> Perhaps you could add libqr to the staging tree?  As long as it
>> compiles, it can go there.  Then you can focus on cleanups and bloat
>> removal.  In the process, you'll get a larger testing base because it
>> will be in mainline.
>
> Yea that is a better way. However, the current state of the code has
> several problems:
>
> * No good error handling (simply returns -1 on failure no matter what)
>    I have began converting this to the ERR_PTR et al interface
>    However, I have not yet done this fully due to the vast amount
>    of work required to do so.
>    This shouldn't be yet merged, but I shall send it as patches once
>    it gets into the staging tree.
>
> * All memory allocations are GFP_ATOMIC for no reason.
>    I have converted them to GFP_KERNEL since we can block safely.
>    This could be merged to Teodora's branch. I can send her a pull
>    request on GitHub if she wants so.

Since we are talking about some kernel Oopses I thought that making
this GFP_ATOMIC ensures that we get memory allocation. I have
considered using GFP_KERNEL, but I am not very sure about that.
Probably somewhere deep inside I wanted to make it work even for
panics. :(

>
> * Selecting QR_OOPS and QRLIB currently does not build due to
>    undefined references to zlib_deflate* functions.
>    This is due to QRLIB not selecting ZLIB_DEFLATE.
>    Fixed this as well. Can be merged to Teodora if she wants.

Hmm, that's odd. I thought I added a 'depends' in the menu. Please
make a pull request and I'll merge it immediately.

>
> * I had trouble getting QR output.
>    Doing 'echo c > /proc/sysrq-trigger' triggered a crash,
>    but it resulted in a recursive OOPS. This is a nullptr-deref
>    and hence I think it may be related to the fact I was running
>    it in textmode. :-)
>    Or, it is due to the bugged error handling.

The QR output is written to the frame buffer. That means you have to
get acces to a console. As I mentioned in the RFC, I am looking for an
alternative to using fb.h since that doesn't seem to work very well
atm.

>
>>
>> You may be interested in objdiff [1] which I'm using for merging code
>> into the staging tree [2].  It provides an automated way to determine
>> that code cleanups didn't change the resultant object code.  You can see
>> an example run here [3].

I'll take a look. Thanks!

>>
>> I would definitely like to see the QR output incorporated into a
>> kernel.org url.  That would remove the need for installing another app,
>> and would ease bug reporting.
>
> I still struggle to understand how could that be done. We can encode the
> QR code as ASCII. Okay, that's fine, however it is very long. Encoding
> 'Unable to handle kernel paging request at 0000000f' gave a 449 character
> long sequence with very strange characters [0]. We should try to shorten
> it, imho. Not sure how to do that though.
>
> oops.kernel.org/?qr=CODE  would look cool though. :-)

I am not very sure that could be done. Accessing the QR code through a
link would mean you have to send it automatically to kernel.org (that
assumes a great deal of things like working Internet connection) and
it misses the point of having a QR code in the first place. The way I
see it, having a QR decoder app installed that can do an offline
decoding is a less greater effort than popping out a browser on the
machine you're working on.

And plus, as Levente said, encoding the QR code which does the Oops
message encoding as text again (which would be large) would generate a
very large link.

--
Teodora

>>
>> Anyway, if you're interested, I'll be re-posting a patch for objdiff
>> separately maybe today or this weekend.
>
>
> [0]: http://paste.fedoraproject.org/87665/39550664/
>
>
> --
> Regards,
> Levente Kurusa

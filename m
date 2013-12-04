Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab3LDS6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:58:13 -0500
Received: from smtp42.i.mail.ru ([94.100.177.102]:50609 "EHLO smtp42.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089Ab3LDS6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:58:11 -0500
X-Greylist: delayed 85153 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2013 13:58:11 EST
Message-ID: <529F7B35.4050509@list.ru>
Date: Wed, 04 Dec 2013 22:57:57 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>, Pavel Machek <pavel@ucw.cz>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Caylan Van Larson <i@caylan.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <5291E92F.7010609@hurleysoftware.com> <1385428582-5577-1-git-send-email-peter@hurleysoftware.com> <529D236E.4020002@hurleysoftware.com> <529D9DCD.5080003@list.ru> <529E0E1F.4010303@hurleysoftware.com> <529E2E92.4010004@list.ru> <529E6F02.70506@hurleysoftware.com>
In-Reply-To: <529E6F02.70506@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04.12.2013 03:53, Peter Hurley пишет:
> On 12/03/2013 02:18 PM, Stas Sergeev wrote:
>> 03.12.2013 21:00, Peter Hurley пишет:
>>> Any unit test is specifically designed to break the code under test.
>>> This unit test does in fact break a possible input: note specifically
>>> that the writer is not changing the termios so has no control over
>>> the timing of when the input is received.
>>>
>>> Also note that the test is a simulation; the patch will break any
>>> input stream under the following conditions:
>>> 1. The writer writes an EOF-terminated buffer
>>> 2. All the input is received _except_ the EOF; this is strictly
>>>    timing-related and not controllable.
>>> 3. The reader changes the termios from non-canon -> canon.
>>>
>>> At that point the damage is done; the read_flags will indicate
>>> 2 EOFs and the 2nd EOF will be interpreted as end-of-file because
>>> it will appear to begin on a new line.
>> How is this different from the unpatched kernel?
>> In the unpatched kernel, if you happen on reader side
>> to enable icanon while n_tty received all but VEOF (is this possible 
>> at all?),
>> then the buffer will be flushed, and the remaining VEOF
>> will get you a nice EOF.
>> So, in the unpatched kernel you get EOF because the buffer
>> gets wiped.
>
> ???
>
> Testcase output from 3.12 w/o patch:
OK, sorry, after a year of rot of my patch in bugzilla, I've
completely forgot the pre-conditions, which is that the
buffer is not discarded, just not pushed.

> Consider the total brute-force approach; a shadow read_flags that
> distinguishes a real EOF receive from the fake EOF push initiated
> by the patch.
What is to do with them?
Remove all "fake" EOFs on receiving the real one?
But that will depend on whether the reader happened to
read everything before the real one arrived.
I think that changing termios on reader side while another
process is writing, is full of surprises. For example, even in
your test-case (without the patch) the writer could expect
that the reader would receive the VEOF char in raw mode.
But the reader switced icanon and the VEOF char is not being read.
And I am sure there are other oddities to suspect, so why
the unexpected EOF is any worse?

> That would work, but I'm looking for a solution more
> space-efficient and simpler than a duplicate 256-byte buffer 
I think "fake" EOFs do not need the entire bitmap.
It is only important to remember the position where icanon was
enabled the last time I suppose, even if it was switched many
times.

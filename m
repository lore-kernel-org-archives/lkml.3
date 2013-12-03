Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3LCRAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:00:37 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59018 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752412Ab3LCRAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:00:35 -0500
Message-ID: <529E0E1F.4010303@hurleysoftware.com>
Date: Tue, 03 Dec 2013 12:00:15 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
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
References: <5291E92F.7010609@hurleysoftware.com> <1385428582-5577-1-git-send-email-peter@hurleysoftware.com> <529D236E.4020002@hurleysoftware.com> <529D9DCD.5080003@list.ru>
In-Reply-To: <529D9DCD.5080003@list.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 04:01 AM, Stas Sergeev wrote:
> 03.12.2013 04:18, Peter Hurley пишет:
>> Unfortunately, this patch breaks EOF push handling.
>>
>> Normally, when an EOF is found not at the line start, the output
>> is made available to a canonical reader (without the EOF) -- this is
>> commonly referred to as EOF push. An EOF at the beginning of a line
>> forces the read to return 0 bytes read, which the caller interprets
>> as an end-of-file and discontinues reading.
>>
>> Since this patch simulates an EOF push, an actual EOF push that
>> follows will appear to be an EOF at the beginning of a line and
>> cause read to return 0, thus indicating premature end-of-file.
>>
>> I've attached a simulation testcase that shows the unexpected EOF.
>>
>> I think this general approach is still the way forward with this bug
>> but I need to ponder how the simulated EOF push state can properly be
>> distinguished from the other eol conditions in canon_copy_from_read_buf()
>> so line_start is not reset to the read_tail.
> Hi Peter, why do you think this is even a problem?
> If you enable icanon and the first thing you did was
> to send VEOF, then you need an EOF.
> If you want to be backward-compatible, you'll likely need
> to go that route, because currently it works exactly that
> way, except that the read buffer is lost. Other than preserving
> the read buffer, my patch was not supposed to change anything.
> I already have a program (written, tested, went to customer,
> used in production, oops sorry:) that switches to icanon and
> sends VEOF to simulate EOF. If you change this, then the behaviour
> will depend on whether the reader happened to read the data
> while still in RAW mode or already in icanon mode, which will
> create an unfixable race.
>
> I think the only reliable and consistent fix would be to add ioctls
> for EOF and EOL pushes. Then people will not even need to switch
> back-n-forth like crazy. But as things are now, I think my patch
> is conservative and safe. Do you think it can break something real,
> other than the test-case? I think your test-case was made with the
> particular patch in mind, but it is not compatible with the current
> kernel, so it can't be "broken".

Stas,

Any unit test is specifically designed to break the code under test.
This unit test does in fact break a possible input: note specifically
that the writer is not changing the termios so has no control over
the timing of when the input is received.

Also note that the test is a simulation; the patch will break any
input stream under the following conditions:
1. The writer writes an EOF-terminated buffer
2. All the input is received _except_ the EOF; this is strictly
    timing-related and not controllable.
3. The reader changes the termios from non-canon -> canon.

At that point the damage is done; the read_flags will indicate
2 EOFs and the 2nd EOF will be interpreted as end-of-file because
it will appear to begin on a new line.

That said, this problem is definitely solvable; I'm just looking
for the best way to solve it.

Consider the total brute-force approach; a shadow read_flags that
distinguishes a real EOF receive from the fake EOF push initiated
by the patch. That would work, but I'm looking for a solution more
space-efficient and simpler than a duplicate 256-byte buffer :)

Regards,
Peter Hurley


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3IZUHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:07:09 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56515 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133Ab3IZUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:07:06 -0400
Message-ID: <524493E6.60300@hurleysoftware.com>
Date: Thu, 26 Sep 2013 16:07:02 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mikael Pettersson <mikpelinux@gmail.com>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][BISECTED] 3.12-rc "n_tty: Don't wait for buffer
 work in read() loop" patch breaks gcc's testsuite
References: <21058.54396.663197.35823@pilspetsen.it.uu.se> <5242EA1C.7050008@hurleysoftware.com> <5242EAA1.7060507@hurleysoftware.com>
In-Reply-To: <5242EAA1.7060507@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 09:52 AM, Peter Hurley wrote:
> [ +cc Greg Kroah-Hartman ]
>
> On 09/25/2013 09:50 AM, Peter Hurley wrote:
>> On 09/25/2013 08:18 AM, Mikael Pettersson wrote:
>>> With 3.12-rc[12] I see unexpected failures in gcc's Ada acats testsuite, e.g.
>>>
>>>                  === acats tests ===
>>> FAIL:   a83009b
>>> FAIL:   c37209a
>>> FAIL:   c45531e
>>> FAIL:   c45614a
>>> FAIL:   c67005d
>>> FAIL:   c730a01
>>> FAIL:   c74302b
>>> FAIL:   cc3004a
>>> FAIL:   cd2a24j
>>> FAIL:   cd2a53a
>>> FAIL:   cxa3001
>>> FAIL:   cxf3a07
>>> FAIL:   cxf3a08
>>>
>>>                  === acats Summary ===
>>> # of expected passes            2307
>>> # of unexpected failures        13
>>> Native configuration is x86_64-unknown-linux-gnu
>>
>> Thanks for the report.
>> Would you please send me the acats.log file from a failed testsuite run with its
>> matching screen output?
>>
>> Regards,
>> Peter Hurley
>>
>>
>>> The exact failures vary from run to run, but some failures always occur on my
>>> x86_64 machines, and all three open gcc branches (trunk, 4.8, 4.7) are affected.
>>> With a 3.11 kernel the acats testsuite is always clean.
>>>
>>> A bisection identified:
>>>
>>>  From f95499c3030fe1bfad57745f2db1959c5b43dca8 Mon Sep 17 00:00:00 2001
>>> From: Peter Hurley <peter@hurleysoftware.com>
>>> Date: Sat, 15 Jun 2013 13:14:29 +0000
>>> Subject: n_tty: Don't wait for buffer work in read() loop
>>>
>>> User-space read() can run concurrently with receiving from device;
>>> waiting for receive_buf() to complete is not required.
>>>
>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>>> index fe1c399..a6eea30 100644
>>> --- a/drivers/tty/n_tty.c
>>> +++ b/drivers/tty/n_tty.c
>>> @@ -1724,7 +1724,6 @@ static inline int input_available_p(struct tty_struct *tty, int amt)
>>>   {
>>>          struct n_tty_data *ldata = tty->disc_data;
>>>
>>> -       tty_flush_to_ldisc(tty);
>>>          if (ldata->icanon && !L_EXTPROC(tty)) {
>>>                  if (ldata->canon_head != ldata->read_tail)
>>>                          return 1;
>>>
>>> as the culprit.  Reverting that from 3.12-rc2 eliminates the acats failures
>>> and brings the gcc testsuite results to what one gets with 3.11.
>>>
>>> I can't pretend to understand exactly what goes wrong, suffice it to say that
>>> the gcc testsuite harness uses a combination of shell, expect, and tcl.  I
>>> suspect ptys are also involved.
>>>
>>> To repeat, bootstrap a recent gcc 4.8 snapshot w/ ada in --enable-languages,
>>> then run the test suite with "make -j6 -k check; make mail-report.log".
>>> (Adjust -jN as appropriate, but -j6 is what I'm using on my quad-core i7s.)

Ok, I've managed to reproduce this (epic adventure).

What happens is the child process (the test) writes to its stdout (which is
the slave end of a pty pair) and exits.

Then, the parent (expect), waiting for output from the child, is scheduled
and run before the tty buffer i/o loop has pushed any data to the pty master
read buffer.

IOW, at that particular instant, the pty appears to be closed (read return -EIO).

(The converse is also possible: ie., writing to the master and then closing
the master may not be read by the slave.)

>>> Please consider reverting or fixing this patch.

I need to think a little on the right way to fix this.

Regards,
Peter Hurley

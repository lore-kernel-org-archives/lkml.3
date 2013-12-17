Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3LQRq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:46:27 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47075 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753798Ab3LQRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:46:26 -0500
Message-ID: <52B08DEB.5050304@hurleysoftware.com>
Date: Tue, 17 Dec 2013 12:46:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Karl Dahlke <eklhad@comcast.net>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Bug in tty cooked mode kernel 3.12.3
References: <20131107184607.eklhad@comcast.net> <1386630367-4658-1-git-send-email-peter@hurleysoftware.com> <20131217173052.GA15633@kroah.com>
In-Reply-To: <20131217173052.GA15633@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 12:30 PM, Greg Kroah-Hartman wrote:
> On Mon, Dec 09, 2013 at 06:06:07PM -0500, Peter Hurley wrote:
>> On 12/07/2013 06:46 PM, Karl Dahlke wrote:
>>> This may have appeared in 3.9.11 with the changes to tty.
>>> Don't know; I just started running 3.12 from kernel.org.
>>> Perhaps nobody saw it before because nobody runs command line programs,
>>> we're all on desktops or x or whatever,
>>> and even those in the command line are still raw.
>>> bash is raw by default, but I run it cooked.
>>> You can supress its readline functions like this.
>>>
>>> set +o emacs
>>> set +o vi
>>> set +o histexpand
>>> set +o history
>>>
>>> That puts its tty back into cooked mode.
>>>
>>> Come up in run level 3, command line mode,
>>> and bring up two consoles with bash in cooked mode as above.
>>> Set a simple prompt like this.
>>>
>>> PS1='$ '
>>>
>>> Switch to console 2 via alt-f2.
>>> Hit return.
>>> The cursor should drop to a new line then give you the $ prompt.
>>> But it puts the $ prompt next too the old one, then drops down
>>> to a blank line.
>>> The $ prompt and the crlf are out of sequence.
>>> Hit return a few more times and it will straighten itself out.
>>> Then switch back to console 1 alt-f1
>>> Hit return and the same bug,
>>> $ $
>>>
>>> hit return a few more times to straighten it out.
>>> Switch back to console 2 and the same problem.
>>> For me it's repeatable.
>>>
>>> It's also very confusing when I'm running other command line programs with cooked tty.
>>> For unknown reasons the crlf can come out at the wrong time,
>>> breaking lines or leaving lines together.
>>> My editor can run either way, so I've switched it over to readline mode
>>> and I haven't noticed any problems this way, yet.
>>> But I would prefer the cooked mode.
>>>
>>> I looked through MAINTAINERS but couldn't find
>>> a clear maintainer for drivers/tty/tty*.c
>>> Please forward this to the appropriate people.
>>
>> Thanks for the report, Karl.
>>
>> Please test the patch below (requires
>> commit 39434abd942c8e4b9c14c06a03b3245beaf8467f,
>> 'n_tty: Fix missing newline echo').
>> This should fix the 'newline output after the new prompt' problem.
>>
>> Note however that the other output order you observe is correct:
>> you press enter, a newline is echoed to terminal which mixes
>> with program output, the program ends, and the cooked mode
>> shell outputs an extra prompt because it reads a newline (which
>> the program did not read).
>>
>> Regards,
>> Peter Hurley
>>
>> --- >% ---
>> From: Peter Hurley <peter@hurleysoftware.com>
>> Subject: [PATCH] n_tty: Fix apparent order of echoed output
>>
>> With block processing of echoed output, observed output order is still
>> required. Push completed echoes and echo commands prior to output.
>>
>> Introduce echo_mark echo buffer index, which tracks completed echo
>> commands; ie., those submitted via commit_echoes but which may not
>> have been committed. Ensure that completed echoes are output prior
>> to subsequent terminal writes in process_echoes().
>>
>> Fixes newline/prompt output order in cooked mode shell.
>>
>> Cc: <stable@vger.kernel.org> # 3.12.x : 39434ab n_tty: Fix missing newline echo
>> Reported-by: Karl Dahlke <eklhad@comcast.net>
>> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/tty/n_tty.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> Do you want me to queue this up for 3.13-final, or have I already?

Yes, please queue this for 3.13.

Regards,
Peter Hurley


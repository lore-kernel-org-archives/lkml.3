Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3BDP4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:56:03 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:61083 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3BDP4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:56:01 -0500
Message-ID: <510FDA0B.3020408@suse.cz>
Date: Mon, 04 Feb 2013 16:55:55 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Bryan Mason <bmason@redhat.com>
Subject: Re: [PATCH] TTY: do not reset master's packet mode
References: <1358288782-2946-1-git-send-email-jslaby@suse.cz> <CA+5PVA5K8Fuvu_5GmpCS_wmQ5OgaeC9mTwUQfrX22juA3nk6og@mail.gmail.com>
In-Reply-To: <CA+5PVA5K8Fuvu_5GmpCS_wmQ5OgaeC9mTwUQfrX22juA3nk6og@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 06:59 PM, Josh Boyer wrote:
> On Tue, Jan 15, 2013 at 5:26 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>> Now that login from util-linux is forced to drop all references to a
>> TTY which it wants to hangup (to reach reference count 1) we are
>> seeing issues with telnet. When login closes its last reference to the
>> slave PTY, it also resets packet mode on the *master* side. And we
>> have a race here.
>>
>> What telnet does is fork+exec of `login'. Then there are two
>> scenarios:
>> * `login' closes the slave TTY and resets thus master's packet mode,
>>   but even now telnet properly sets the mode, or
>> * `telnetd' sets packet mode on the master, `login' closes the slave
>>   TTY and resets master's packet mode.
>>
>> The former case is OK. However the latter happens in much more cases,
>> by the order of magnitude to be precise. So when one tries to login to
>> such a messed telnet setup, they see the following:
>> inux login:
>>             ogin incorrect
>>
>> Note the missing first letters -- telnet thinks it is still in the
>> packet mode, so when it receives "linux login" from `login', it
>> considers "l" as the type of the packet and strips it.
>>
>> SuS does not mention how the implementation should behave. Both BSDs I
>> checked (Free and Net) do not reset the flag upon the last close.
>>
>> By this I am resurrecting an old bug, see References. We are hitting
>> it regularly now, i.e. with updated util-linux, ergo login.
>>
>> Here, I am changing a behavior introduced back in 2.1 times. It would
>> better have a long time testing before goes upstream.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Bryan Mason <bmason@redhat.com>
>> References: https://lkml.org/lkml/2009/11/11/223
>> References: https://bugzilla.redhat.com/show_bug.cgi?id=504703
>> References: https://bugzilla.novell.com/show_bug.cgi?id=797042
> 
> Shouldn't this be CC'd to stable?

Nope, it will be sent to stable as soon as it proves itself to be stable
enough. Note that we are changing very old code and the last thing we
want to do here is to break stable trees.

thanks,
-- 
js
suse labs

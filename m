Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3EQTXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:23:41 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56187 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3EQTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:23:39 -0400
Message-ID: <5196835B.4060100@ahsoftware.de>
Date: Fri, 17 May 2013 21:22:03 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tty: make sure a BUG is hit if tty_port will be destroyed
 before tty
References: <5195B561.3090503@ahsoftware.de> <1368774728-4817-1-git-send-email-holler@ahsoftware.de> <20130517153136.GC19541@kroah.com> <51965DC0.7030901@ahsoftware.de> <5196718D.30904@hurleysoftware.com>
In-Reply-To: <5196718D.30904@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2013 20:06, schrieb Peter Hurley:
> On 05/17/2013 12:41 PM, Alexander Holler wrote:
>> Am 17.05.2013 17:31, schrieb Greg Kroah-Hartman:
>>> On Fri, May 17, 2013 at 09:12:08AM +0200, Alexander Holler wrote:
>>>> tty depends on tty_port until tty_release() was called. Make sure a BUG
>>>> will be hit, if tty_port will be destroyed before tty.
>>>
>>> So you want to ensure that we crash a machine?  No, please never add
>>
>> Exactly. Let me quote myself:
>>
>>  >> As described before, it ends up with memory corruption because freed
>>  >> memory is used, so if a BUG() happens, it doesn't help much. E.g.
>> with
>>  >> kernel 3.9.2 I never have seen a bug, just a rebooting machine
>>  >> (sometimes minutes after the real bug happened).
>>
>>> BUG() statements to the kernel, unless something _really_ bad is going
>>> to happen if we don't call it.  I never want to stop a machine from
>>> running, do you?
>>
>> Yes. I'm not sure how you define _really_ bad, but a memory corruption
>> with undefined result is exactly how I would define such.
> 
> First, I like the idea of a diagnostic here. But I'm with Greg on
> this; BUG() is overkill. Just because the specific path which you found
> only kills the process doesn't mean that other callers might not
> prompt machine halt.
> 
> The memory corruption happens as a result of the tty_port being freed
> by tty_port_destructor(). So a suitable diagnostic is to detect the
> condition, WARN, and return without actually performing the destroy, yes?
> 
>> And in the case of rfcomm, the box doesn't stop, at least not here.
>> Just the process is killed together with an easy to identfiy oops. And
>> the BUG_ON() prevents that memory will become corrupted and the
>> machine is still usable afterwards. If that isn't a use case for
>> BUG_ON(), I really don't know what else would be a use case for it.

Sorry, I didn't express it such, that this can't be misunderstood.
Without that BUG_ON() in my proposed patch, my boxes always died
afterwards. And that with a lot of different results before. Sometimes
nothing happened and the machine just rebooted, sometimes I've just seen
a warn_slowpath before the machine stopped/rebooted, sometimes I've just
got the BUG I posted in a previous mail, and often I've seen many OOPSes
before the machine rebooted. But in every case, the machine died unexpectly.

The case that the machine didn't die, but just the process, only happens
when my proposed patch is applied, which prevents the memory corruption.

Regards,

Alexander Holler


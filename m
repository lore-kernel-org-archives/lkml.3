Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3JQKnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:43:43 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:50467 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3JQKnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:43:42 -0400
Message-ID: <525FBF5A.3040307@redhat.com>
Date: Thu, 17 Oct 2013 12:43:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] static_key: fix timer bugs & change api (a bit)
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/10/2013 12:10, Radim Krčmář ha scritto:
> While fixing a simple crash on kvm module unload
> 
> 1: rate_limit timer can fire after we free its key's module memory.
> 
> I noticed other deficiencies in jump_label/static_key code
> (The most important is 4.)
> 
> 2: jump_label_rate_limit() uses an initializator and thus cannot be used
>    more than once, leaving no good way to change the timeout.
> 
> I have made the API easier on programmers: [1/7]
>  * timer is automatically flushed on rmmod
>  * jump_label_rate_limit() initializes only once
>     - pretty hacky, but we cannot automatically initialize on
>       kernel_init/insmod due to insufficient information and while I
>       would love getting it through another section, it is probably
>       better to do a useless check with this low-rate operation
>     * we could flush the timer on change
>     * 'init()' + 'set()' (+ 'exit()' ?) would be an alternative ...
> 
> 3: schedule_delayed_work() does not queue the work if one is already
>    pending, but atomic_inc(&key->enabled) is called anyway in
>    static_key_slow_dec_deferred(), with the false belief it will be
>    decreased when the timer fires.
> 
> Fixed in [2,3,4/7], by addition of static_key_slow_inc_deferred().

I think you're doing a bit too much for one series.  Let's focus on the
bugfix and perhaps the improvements to the deferred static key API, that
is patches 1/2/3/4.

Paolo


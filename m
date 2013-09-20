Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3ITQsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:48:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3ITQsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:48:03 -0400
Date: Fri, 20 Sep 2013 18:41:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        roland@hack.frob.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: do_wait: Add missing tasklist unlocking in error paths.
Message-ID: <20130920164144.GA31808@redhat.com>
References: <20130920163733.GA24958@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920163733.GA24958@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Dave Jones wrote:
>
> It looks like both 64a16caf5, and 98abed020 both introduced error paths to do_wait
> where we miss unlocking the tasklist.
>
> Spotted with coverity.

Not really, afaics.

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1526,13 +1526,15 @@ repeat:
>  	tsk = current;
>  	do {
>  		retval = do_wait_thread(wo, tsk);
> -		if (retval)
> +		if (retval) {
> +			read_unlock(&tasklist_lock);

note that do_wait_thread() paths should drop tasklist if it returns non-zero.

Oleg.


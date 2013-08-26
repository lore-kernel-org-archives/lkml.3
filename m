Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3HZWW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:22:26 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:48996 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3HZWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:22:24 -0400
Message-ID: <521BD523.3040706@tilera.com>
Date: Mon, 26 Aug 2013 18:22:27 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, <akpm@linuxfoundation.org>,
        <linux-arch@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [guv v2 23/31] tile: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com> <00000140bc69acdb-3b2967b0-e224-424b-ad08-973515704be6-000000@email.amazonses.com>
In-Reply-To: <00000140bc69acdb-3b2967b0-e224-424b-ad08-973515704be6-000000@email.amazonses.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2013 4:56 PM, Christoph Lameter wrote:
> Index: linux/arch/tile/include/asm/irqflags.h
> ===================================================================
> --- linux.orig/arch/tile/include/asm/irqflags.h	2013-08-22 14:39:14.000000000 -0500
> +++ linux/arch/tile/include/asm/irqflags.h	2013-08-22 14:39:57.453305409 -0500

Nack to the changes to this file, with all due respect :-), since I have conflicting changes in the linux-tile tree that also remove all uses of __get_cpu_var from this file.  Note that there are places in this file where "this_cpu_and", etc., make sense; I don't know if it makes sense for your script to be looking for this kind of thing more generally.

> -		__get_cpu_var(current_asid) = asid;
> +		__this_cpu_read(current_asid) = asid;

This should be __this_cpu_write(current_asid, asid).  You caught this idiom elsewhere so not sure if it was a script bug that caused it to be missed here?

> -	int depth = __get_cpu_var(irq_depth)++;
> +	int depth = __this_cpu_inc_return(irq_depth) - 1;

I would omit the "-1" here and instead change the one test of "depth == 0" to be "depth == 1".

> -	__get_cpu_var(current_asid) = min_asid = asid_range.start;
> +	__this_cpu_write(current_asid, min_asid = asid_range.start);

This was ugly before but now it's much worse :-)  Please just split it into an assignment to min_asid, then use __this_cpu_write() with min_asid.  Thanks.

The rest is fine.  Would it make more sense for me to fold all these changes into the tile tree and just have it meet in linux-next?  There are certainly a bunch of other changes staged there which likely also include more uses of __get_cpu_var...

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


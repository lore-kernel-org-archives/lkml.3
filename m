Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3ETGGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:06:54 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48874 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3ETGGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:06:53 -0400
Message-ID: <5199BD45.5090100@gmail.com>
Date: Sun, 19 May 2013 23:05:57 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>, vikram186@gmail.com
CC: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 05/10 fix] mtd: get the ECC info from the Extended
 Parameter Page
References: <51966AA7.7050007@gmail.com> <1369015705-4720-1-git-send-email-b32955@freescale.com>
In-Reply-To: <1369015705-4720-1-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang, Vikram,

On 05/19/2013 07:08 PM, Huang Shijie wrote:
...
> +	/*
> +	 * From section 5.7.2.2, we know that the Extened Param Page is valid
> +	 * when two or more bytes of the signatrue are valid.

s/signatrue/signature

> +	 * So we only check the first two bytes here.
> +	 */
> +	if (strncmp(ep->sig, "EP", 2)) {
> +		pr_debug("The signatrue is invalid.\n");

Ditto.

> +		goto ext_out;
> +	}

What's the reasoning about this whole "only check 2 bytes" thing? I 
understand that this is technically what spec *says* (although you're 
actually not checking the other 5 combinations that are valid: 'ExPx' 
'ExxS' 'xPPx' 'xPxS' 'xxPS'). But *why* does the spec say this? To 
tolerate errors or to tolerate changes in the spec (e.g., new types of 
parameter pages that say 'QPPS' [1], for instance)? The former doesn't 
really sound plausible, since if we're going to have 2 whole bytes of 
errors in the signature, then we really shouldn't trust the whole 
(extended) parameter page. And the latter doesn't really make sense to 
me; any future backwards-compatible modifications should just use the 
same signature string.

Anyway, my point is that there has to be some logic to strictly 
following the letter of the specification. Shortening the check to just 
the 2-byte "EP" string does not actually cover *exactly* what the spec 
might allow (e.g., it doesn't allow "QPPS" [1]). But it also doesn't 
make any sense why we want to check anything besides "EPPS". So my 
natural inclination is to be strict in what we accept (i.e., exactly the 
"EPPS" string) until we find a reason otherwise.

Or, if you're gonna pull the strict compliance card, check all 6 
combinations, not just 1 of them.

Brian

[1] This is a totally made-up example. I do not understand at all why 
ONFI would allow anything besides exactly "EPPS".

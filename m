Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaGVNwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:52:50 -0400
Received: from canardo.mork.no ([148.122.252.1]:37356 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaGVNwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:52:49 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Michal Marek <mmarek@suse.cz>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: coccinelle: kfree with TRACE_RET before ref is ok (resent)
Organization: m
References: <20140722101217.GA16183@opentech.at>
Date: Tue, 22 Jul 2014 15:51:25 +0200
In-Reply-To: <20140722101217.GA16183@opentech.at> (Nicholas Mc Guire's message
	of "Tue, 22 Jul 2014 12:12:17 +0200")
Message-ID: <87ha298psy.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Mc Guire <der.herr@hofr.at> writes:

> kfree.cocci currently triggers on constructs like
> (resending with proper CC list and subject line)
>
> drivers/staging/rts5208/spi.c
> 596    if (retval < 0) {
> 597            kfree(buf);
> 598            rtsx_clear_spi_error(chip);
> 599            spi_set_err_code(chip, SPI_HW_ERR);
> 600            TRACE_RET(chip, STATUS_FAIL);
> 601    }
> 602
> 603    rtsx_stor_access_xfer_buf(buf, pagelen, srb, &index, &offset,
>                             TO_XFER_BUF);
>
> with:
>
> ./drivers/staging/rts5208/spi.c:603:28-31: ERROR: reference preceded 
> by free on line 597
>
> but this should be fine - so TRACE_RET is added to the list of calls 
> "protecting" access to freed objects see drivers/staging/rts5208/trace.h

The TRACE_RET macro is a serious coding style violation. Fix that and
the error will go away.  Don't change scripts to hide issues with the
code. The code above won't just trigger an error in kfree.cocci but also
in the head of any sane person.

>From Documentation/CodingStyle:

<quote>
Things to avoid when using macros:

1) macros that affect control flow:

#define FOO(x)                                  \
        do {                                    \
                if (blah(x) < 0)                \
                        return -EBUGGERED;      \
        } while(0)

is a _very_ bad idea.  It looks like a function call but exits the "calling"
function; don't break the internal parsers of those who will read the code.
</quote>


Bjørn

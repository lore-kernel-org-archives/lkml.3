Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3IJAPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:15:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3IJAPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:15:34 -0400
Date: Mon, 9 Sep 2013 20:15:29 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kyle McMartin <kyle@infradead.org>,
        linux-kernel@vger.kernel.org, jstancek@redhat.com,
        keescook@chromium.org, peter.oberparleiter@de.ibm.com,
        linux-arch@vger.kernel.org, arnd@arndb.de, mgahagan@redhat.com,
        agospoda@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 4/4] kernel: add support for init_array constructors
Message-ID: <20130910001529.GE25882@merlin.infradead.org>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
 <1378305776-3644-5-git-send-email-fhrbata@redhat.com>
 <87vc2e66kr.fsf@rustcorp.com.au>
 <20130906175118.GB2332@localhost.localdomain>
 <20130906180751.GD25882@merlin.infradead.org>
 <87d2oi6bl0.fsf@rustcorp.com.au>
 <20130909162814.GA2288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909162814.GA2288@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:28:14PM +0200, Frantisek Hrbata wrote:
> I'm not sure if coexistence of .ctors and .init_array sections should result in
> denial of module, but I for sure know nothing about this :). Could you maybe
> privide one example of the "weird thing"?
> 

They shouldn't exist unless placed there intentionally... I suspect a
call_if_changed Makefile target to regenerated a header would solve this
problem sufficiently for a given toolchain version.

A little exposition:
.init_array and .ctors are laid out on top of each other, with an
ordering that's a bit complicated... the sort of the ctor functions ends
up being .ctor.x upwards towards 65535, and .init_array.x downwards
from 65535 towards 0, with priority 65535-x, so that

.init_array.32768 would be called before .ctor.32768.

It's all a complete mess.

Perhaps if CONFIG_GCOV is on, we should enforce MODVERSIONS and make
sure the GCC version doesn't change for the running kernel?

Maybe it would be sufficient to just detect what the toolchain supports
and do that? I have a patch based on the configure.ac in gcc that
does something like that, which would be trivial to use to generate a
header based on gcc version.

> Anyway many thanks for taking time to look at this. Below is my attepmt to
> implement the check you proposed. 
> 
> untested/uncompiled

regards, Kyle

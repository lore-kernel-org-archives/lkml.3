Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaACBo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:44:57 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:36836 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaACBo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:44:56 -0500
MIME-Version: 1.0
In-Reply-To: <1388710666.2259.71.camel@joe-AO722>
References: <CAKZGPAMmtDNYQfMnujG9pozkn=xd8=9hoB++8avqxgbYomvhTQ@mail.gmail.com>
 <20140102145548.f3fe2c3fd3ea706ed388685c@linux-foundation.org> <1388710666.2259.71.camel@joe-AO722>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 3 Jan 2014 02:44:35 +0100
Message-ID: <CAPXgP10DL7H9njGJ74eiKfEMo_n5M_qzx5HYXstVSvOfPVPu5A@mail.gmail.com>
Subject: Re: [PATCH] printk: flush conflicting continuation line
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arun KS <arunks.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, fweisbec@gmail.com,
        paul.gortmaker@windriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 1:57 AM, Joe Perches <joe@perches.com> wrote:
> (Adding Kay to cc's)
>
> Kay?  any opinion on correctness?

Sounds fine by looking at it. Did not test anything though.

>> > --- a/kernel/printk/printk.c
>> > +++ b/kernel/printk/printk.c
>> > @@ -1604,7 +1604,10 @@ asmlinkage int vprintk_emit(int facility, int level,
>> >   if (!(lflags & LOG_PREFIX))
>> >   stored = cont_add(facility, level, text, text_len);
>> >   cont_flush(LOG_NEWLINE);
>> > - }
>> > + /* Flush conflicting buffer. An earlier newline was missing
>> > + * and current print is from different task */
>> > + } else if (cont.len && cont.owner != current)
>> > + cont_flush(LOG_NEWLINE);

Unless I miss something, this whole sections all go inside a:
  if (cont.len) {
    ...
    cont_flush(LOG_NEWLINE);
  }

and look a bit less confusing than the two conditions with just the
negated "current" check and duplicated flush call?

Kay

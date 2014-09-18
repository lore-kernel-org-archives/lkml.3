Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaIRRa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbaIRRay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:30:54 -0400
Date: Thu, 18 Sep 2014 19:28:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] init: fix race between rootfs mount and
	firmware loading
Message-ID: <20140918172812.GA340@redhat.com>
References: <CACZ9PQXJzoczS7gN5UCFygTHrLW5Rtjew5BF-txfL=cryE331w@mail.gmail.com> <1410960495-9198-1-git-send-email-r.peniaev@gmail.com> <20140917174647.GC19308@redhat.com> <CACZ9PQV0uQ+0Nzn10tCxyVo0_8qRFexh0iQLQErAkFc1T2WGHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQV0uQ+0Nzn10tCxyVo0_8qRFexh0iQLQErAkFc1T2WGHA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Roman Peniaev wrote:
>
> If my final understanding is right (please, correct me if I am still wrong),
> following reordering can happen, but we are fine with it:
>
> wake_up_rootfs                 wait_event
>
> LOCK
> check the list, but empty
> set CONDITION <<< reordered
> UNLOCK

Yes,

>                                           LOCK
>                                           add to the list
>                                           rmb            <<< now we
> see CONDITION

Yes, but note that "now we see CONDITION" is true right after LOCK,
not sure what does this "rmb" in your pseudo mean. If you meant mb()
implied by set_current_state(), please see the comment above
prepare_to_wait().

>                                           UNLOCK
>
>                                           check CONDITION <<< it is
> set, we are woken up

Yes. In short, we rely on wait_queue_head_t->lock. Once a CPU takes
this lock, it should see all changes done by another CPU before it
released the same lock.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbbAANzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:55:54 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48035 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbAANzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <CABkLObqhqE7Y3eD2gUxmqb0etfvYcDYRnE=-i=-4j=4Ea6=F-w@mail.gmail.com>
References: <1419941156-5303-1-git-send-email-peter@hurleysoftware.com>
	<CABkLObqhqE7Y3eD2gUxmqb0etfvYcDYRnE=-i=-4j=4Ea6=F-w@mail.gmail.com>
Date: Thu, 1 Jan 2015 14:55:50 +0100
X-Google-Sender-Auth: mHXT0W9d8neYuxkDa3WhjzNQBNk
Message-ID: <CABkLObp9jt6y94Ss6H=F2UGm4n1kv9jJU2tJfdg+EUO=e=BVNw@mail.gmail.com>
Subject: Re: [PATCH] n_tty: Fix unordered accesses to lockless read buffer
From: Christian Riesch <christian.riesch@omicron.at>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 12:00 PM, Christian Riesch >> @@ -164,15
+160,17 @@ static inline int tty_put_user(struct tty_struct *tty,
unsigned char x,
>>  static int receive_room(struct tty_struct *tty)
>>  {
>>         struct n_tty_data *ldata = tty->disc_data;
>> +       size_t head = ACCESS_ONCE(ldata->commit_head);
>> +       size_t tail = ACCESS_ONCE(ldata->read_tail);
>>         int left;
>>
>>         if (I_PARMRK(tty)) {
>> -               /* Multiply read_cnt by 3, since each byte might take up to
>> +               /* Multiply count by 3, since each byte might take up to
>>                  * three times as many spaces when PARMRK is set (depending on
>>                  * its flags, e.g. parity error). */
>> -               left = N_TTY_BUF_SIZE - read_cnt(ldata) * 3 - 1;
>> +               left = N_TTY_BUF_SIZE - (head - tail) * 3 - 1;
>>         } else
>> -               left = N_TTY_BUF_SIZE - read_cnt(ldata) - 1;
>> +               left = N_TTY_BUF_SIZE - (head - tail) - 1;
>
> Actually, less room may be available, if read_head != commit_head.
> Could this cause problems? I guess yes, at least in
> n_tty_receive_buf_common, where this could lead to a buffer overflow,
> right?

Sorry, should not be a problem, at least not for
n_tty_receive_buf_common, since this is producer path, right? But how
about the other calls of receive_room()?

Christian

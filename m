Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AWEkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:40:45 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:38859 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3AWEko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:40:44 -0500
Message-ID: <50FF69C6.2040705@gmail.com>
Date: Wed, 23 Jan 2013 12:40:38 +0800
From: snakky.zhang@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Is this a bug that n_tty_set_room not serialized? If so please correct
 it.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

Seems there is an bug related to function n_tty_set_roomin source file
drivers/tty/n_tty.c. This function is used to set receive_room based on
the read_cntby both the consumer and the producer of the tty's read buffer.

But this function is not serialized, so I am afraid there is
a risk like: The producer make the buffer full and then call this 
function to
set the receive_room to 0; while it is preempted by the consumer that empty
the buffer(read_cnt is 0)and then call this very function to set the
receive_room to a non-zero value. But when the producer continue, 
receive_room
was set to 0 again. Thus both read_cnt and receive_room is 0.For consumer
theread_cnt is 0 that no data can be read; while for the producer, 
thebuffer
is full since the receive_room is 0. Both of them blockhere...

Two methods to avoid it:
A) Addor find a lock to serialize this function;
B) Once the producer find the buffer is full, double check/set the 
buffer with
n_tty_set_room. For example in function "flush_to_ldisc".

Please correct me if I misunderstand something. Or please fix it.

Thanks
Xiao

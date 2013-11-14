Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3KNLgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:36:55 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51867 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3KNLgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:36:53 -0500
Message-ID: <5284B5D2.70206@hitachi.com>
Date: Thu, 14 Nov 2013 20:36:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v3 4/8] x86: speed up int3-based patching using direct
 write
References: <1384425686-21018-1-git-send-email-pmladek@suse.cz> <1384425686-21018-5-git-send-email-pmladek@suse.cz>
In-Reply-To: <1384425686-21018-5-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/14 19:41), Petr Mladek wrote:
> @@ -837,7 +882,7 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
>  	}
>  
>  	/* Finally, put back the first byte from the old code */
> -	err = text_poke(addr, old_opcode, sizeof(bp_int3));
> +	err = text_poke_part(addr, old_opcode, sizeof(bp_int3));
>  	/* we can not continue if the interrupt is still there */
>  	BUG_ON(err);
>  }
> @@ -865,7 +910,9 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
>   * It is a bit more paranoid than text_poke_bp because it checks the actual
>   * code before patching. This is a good practice proposed by the ftrace code.
>   *
> - * Note: This function must be called under text_mutex.
> + * Note: This function must be called under text_mutex. Also the caller is
> + * responsible for making the patched code read-write, for example using
> + * set_kernel_text_rw() and set_all_modules_text_rw()

OK, I got the reason why we can do it.
But if so, we should change all existing caller of text_poke_bp() to
call it in this patch, or they must fail at this point.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



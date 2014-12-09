Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaLIIwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:52:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaLIIwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:52:21 -0500
Date: Tue, 9 Dec 2014 11:52:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: potential corruption in synclink driver
Message-ID: <20141209085205.GA28655@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, I hate to bother you with this, but you're the TTY expert.  I'm
getting the following static checker warning:

	drivers/tty/synclink.c:4057 save_tx_buffer_request()
	error: 'BufferSize' from user is not capped properly

drivers/tty/synclink.c
  4047  static int save_tx_buffer_request(struct mgsl_struct *info,const char *Buffer, unsigned int BufferSize)
  4048  {
  4049          struct tx_holding_buffer *ptx;
  4050  
  4051          if ( info->tx_holding_count >= info->num_tx_holding_buffers ) {
  4052                  return 0;               /* all buffers in use */
  4053          }
  4054  
  4055          ptx = &info->tx_holding_buffers[info->put_tx_holding_index];
  4056          ptx->buffer_size = BufferSize;
  4057          memcpy( ptx->buffer, Buffer, BufferSize);
                                             ^^^^^^^^^^
  4058  
  4059          ++info->tx_holding_count;
  4060          if ( ++info->put_tx_holding_index >= info->num_tx_holding_buffers)
  4061                  info->put_tx_holding_index=0;
  4062  
  4063          return 1;
  4064  }

ptx->buffer is allocated in mgsl_alloc_intermediate_txbuffer_memory()
and it can be up to "info->max_frame_size" bytes which is a number
between 4096 and 65535.

The way I read it, BufferSize comes from do_tty_write() and it could be
up to 65536.  That's obviously one higher than 65535.  But if
->max_frame_size is 4096 then that's a lot higher.

This looks like a potential buffer overflow but I don't know the TTY
layer enough to be sure.

regards,
dan carpenter

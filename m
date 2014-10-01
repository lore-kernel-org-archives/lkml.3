Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaJAP6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:58:05 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:44151 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaJAP6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <20141001152910.GA4440@wfg-t540p.sh.intel.com>
References: <20141001152910.GA4440@wfg-t540p.sh.intel.com>
From: Willem de Bruijn <willemb@google.com>
Date: Wed, 1 Oct 2014 11:57:31 -0400
Message-ID: <CA+FuTSdgvgt_5HwRdY=OA+dv=nds4VELQ-ZAXdxmHJ3mr0CDnQ@mail.gmail.com>
Subject: Re: [LKP] [net] 4ed2d765dfa: ltp.recv01.4.TFAIL
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 11:29 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Willem,
>
> FYI, we noticed the below LTP failures on commit

Thanks for the report, Fengguang. The failures are

recv01      4  TFAIL  :  recv01.c:142: invalid flags set ; returned -1
(expected -1), errno 11 (expected 22)
recvfrom01    4  TFAIL  :  recvfrom01.c:164: invalid socket length ;
returned -1 (expected -1), errno 11 (expected 22)
recvfrom01    6  TFAIL  :  recvfrom01.c:164: invalid flags set ;
returned -1 (expected -1), errno 11 (expected 22)
recvmsg01    9  TFAIL  :  recvmsg01.c:228: invalid flags set ;
returned -1 (expected -1), errno 11 (expected 22)

In other words, these functions return EAGAIN now, when they used to
return EINVAL. This will happen from this patch onwards if flags
includes MSG_ERRQUEUE. The patch introduced error queue support for
TCP sockets. Like other recvmsg implementations, the error queue code
will act on some flags and ignore others. Previously, the code
happened to check MSG_OOB first and return EINVAL. The error queue
code ignores this flag and returns EAGAIN if no data is waiting.

This was recently discussed in

  LTP recv/recvmsg tests failing on 3.17
  http://comments.gmane.org/gmane.linux.network/331750

where the consensus was that applications should not expect
particular error codes when passing unsupported combinations
of flags.

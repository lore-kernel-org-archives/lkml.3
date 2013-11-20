Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3KTV2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:28:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18548 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3KTV2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:28:34 -0500
MIME-Version: 1.0
Message-ID: <c4336a61-61bd-44bb-bd76-04171e387965@default>
Date: Wed, 20 Nov 2013 13:28:24 -0800 (PST)
From: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: honli@redhat.com, joshhunt00@gmail.com, jjolly@suse.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: RE: [PATCH] rds: Error on offset mismatch if not loopback
References: <528587D0.5060105@redhat.com>
 <8744a6a4-d7a8-4e6f-8934-48a4fd4da0ce@default>
 <25bef391-380b-486a-b06f-8be210e8abb7@default>
 <20131120.135457.154965902030101577.davem@davemloft.net>
In-Reply-To: <20131120.135457.154965902030101577.davem@davemloft.net>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.8  (707110) [OL
 12.0.6680.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why are you posting this message a second time?

Reposting just the contents of the second message in case it got missed the previous time.

Looks like the fix pointed to by the previous link is for a panic on a PPC system with a PAGE_SIZE of 64Kbytes.
I think the sequence it was going through before that fix was:
/* Do not send cong updates to IB loopback */
        if (conn->c_loopback
            && rm->m_inc.i_hdr.h_flags & RDS_FLAG_CONG_BITMAP) {
                rds_cong_map_updated(conn->c_fcong, ~(u64) 0);
                return sizeof(struct rds_header) + RDS_CONG_MAP_BYTES;
        }
rds_ib_xmit returns 8240
rds_send_xmit : c_xmit_data_off = 0 + 8240 - 48 (rds header the first time) = 8196
                c_xmit_data_off < 65536 (sg->length)
                calls rds_ib_xmit again
rds_ib_xmit returns 8240
rds_send_xmit: c_xmit_data_off = 8192+8240 = 16432 and calls rds_ib_xmit
rds_ib_xmit : returns 8240
rds_send_xmit: c_xmit_data_off 24672 and calls rds_ib_xmit ...
...
and so on till
rds_send_xmit: c_xmit_data_off 57632 and calls rds_ib_xmit
rds_ib_xmit: returns 8240

On the last iteration it hits the below BUG_ON in rds_send_xmit.
while (ret) {
    tmp = min_t(int, ret, sg->length -
                         conn->c_xmit_data_off);
 [tmp = 7904]
    conn->c_xmit_data_off += tmp;
[c_xmit_data_off = 65536]
    ret -= tmp;
[ret = 8240-7904 = 336]
    if (conn->c_xmit_data_off == sg->length) {
         conn->c_xmit_data_off = 0;
         sg++;
         conn->c_xmit_sg++;
         BUG_ON(ret != 0 &&
             conn->c_xmit_sg == rm->data.op_nents);
    }
}

Since the congestion update over loopback is not actually transmitted as a message,
the multiple iterations we see in the case of ppc is unnecessary.
All that rds_ib_xmit needs to do is return a number of bytes that will tell the caller
that we are done with this message.
  
This might fix the original problem without introducing the current panic:
/* Do not send cong updates to IB loopback */
        if (conn->c_loopback
            && rm->m_inc.i_hdr.h_flags & RDS_FLAG_CONG_BITMAP) {
                rds_cong_map_updated(conn->c_fcong, ~(u64) 0);
                scat = &rm->data.op_sg[sg];
                ret = max_t(int, RDS_CONG_MAP_BYTES, scat->length);
                return ret + sizeof(struct rds_header);
        }
It will return 8240 when PAGE_SIZE is 4k and 64k+48 in case of ppc when scat->length is 64k and 
be done with one iteration of rds_send_xmit/rds_ib_xmit loop.

Venkat

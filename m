Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3BLVck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:32:40 -0500
Received: from hubcas2.seas.wustl.edu ([128.252.145.2]:24141 "EHLO
	hubcas2.seas.wustl.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3BLVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:32:39 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 16:32:39 EST
Message-ID: <511AB3C5.2080703@seas.wustl.edu>
Date: Tue, 12 Feb 2013 15:27:33 -0600
From: Professor Berkley Shands <berkley@seas.wustl.edu>
Organization: Department of Computer Science and Engineering
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: NUMA allocations fail to be numa allocated
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [205.158.150.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using libnuma calls on RedHat 6.3 x86_64 with the default kernel and up 
to 3.4.29
don't allocate on the specified numa nodes, even when forced with numactl.

It appears that setting the NUMA policy, and or numa nodes does little 
for large allocations.
Using HUGETLBFS, and you get memory on most any node BUT the one you 
asked for.
It appears that it allocates on the last node that did a free().

Here is a small program to demo the lack of numa awareness from user space.

#include <stdlib.h>
#include <sys/shm.h>
#include <stdio.h>
#include <numa.h>
#include <numaif.h>
#include <sched.h>              // for sched_getcpu() call

static const unsigned long HUGE_PAGE_SIZE = 1UL << 21;  // a 2MB huge page
static const unsigned long HUGE_PAGE_SIZE1 = (1UL << 21) - 1;   // less one
static const unsigned long PAGE_SIZE = 1UL << 10;       // a 4KB page
static const unsigned long PAGE_SIZE1 = (1UL << 10) - 1;        // less one

int VerifyNumaNode(void *ptr,   // address
                    int node,    // target node
                    int Count);  // count of 4KB pages
int MoveAddrToNodeMulti(void *ptr, int node, int Count);

void *Allocate(size_t length, int OnNode)
{
    int shmid = -1;
    void *shmaddr = NULL;
    size_t new_length = length;
    int MaxNumaNode = numa_max_node();   // find highest NUMA number
    int LocalNumaNode = numa_node_of_cpu(sched_getcpu());
    int NewNumaNode = LocalNumaNode;
    unsigned long MaskBits[2] = { 0UL, 0UL };    // up to 128 nodes
    struct bitmask NewMask;
    NewMask.size = 8;            // Max nodes on an HP
    struct bitmask *CurrentMask = numa_get_membind();

    // see if NUMA allocation is desired
    if (OnNode >= 0)
    {
       if (OnNode > MaxNumaNode)
       {
          fprintf(stderr, "Invalid NUMA HUGEPages allocation node %d max 
is %d\n", OnNode, MaxNumaNode);
       }
       else
       {
          NewNumaNode = OnNode;
       }
    }
    MaskBits[0] = 1UL << NewNumaNode;
    numa_set_membind(&NewMask);  // restrict to this node

    if (new_length < HUGE_PAGE_SIZE)     /* 2MB min alloc for huge pages */
    {
       new_length = HUGE_PAGE_SIZE;
    }

    if (new_length & HUGE_PAGE_SIZE1)    /* 2MB min alloc for huge pages */
    {
       new_length = ((new_length >> 21) + 1) << 21;
    }
    if ((shmid = shmget(IPC_PRIVATE, new_length, /* length */
                        SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W)) == -1)
    {
       fprintf(stderr, "shmget() failed for %ldMB\n", (long) (new_length 
 >> 20));
       numa_set_membind(CurrentMask);    // unrestrict to this node
       return NULL;
    }

    shmaddr = shmat(shmid, NULL, 0);
    if (shmaddr == (void *) -1)
    {
       shmctl(shmid, IPC_RMID, NULL);
       numa_set_membind(CurrentMask);    // unrestrict to this node
       return NULL;
    }
    else if ((unsigned long) (shmaddr) & (PAGE_SIZE - 1))
    {
       fprintf(stderr, "huge page allocation was not page aligned\n");
    }

    memset(shmaddr, 0x00, new_length);
    if (VerifyNumaNode(shmaddr, NewNumaNode, new_length / 4096UL) > 0)
    {
       MoveAddrToNodeMulti(shmaddr, NewNumaNode, new_length / 4096UL);
    }
    numa_set_membind(CurrentMask);       // unrestrict to this node
    VerifyNumaNode(shmaddr, NewNumaNode, new_length / 4096UL);
    /* now delete the ID so it will free itself on exit */
    shmctl(shmid, IPC_RMID, NULL);
    return shmaddr;
}

void Free(void *addr)
{
}

int NumaNodeFromAddress(void *Address)
{
    int status[1] = { -1 };
    void *PTR = Address;
    void *PTR2[1] = { NULL };
    PTR2[0] = &PTR;
    int retval = move_pages(0,   // this thread
                            1,   // just one pointer
                            PTR2,        // The given address
                            NULL,        // array of nodes, no moving, 
just asking
                            status,      // array of node results
                            MPOL_MF_MOVE);
    if (retval)
    {
       fprintf(stderr, "Invalid Address %p - No NUMA node\n", Address);
    }
    return status[0];
}

int MoveAddrToNodeMulti(void *ptr, int node, int Count)
{
    unsigned long *PTR = new unsigned long[Count + 1];
    unsigned long *PTR2 = new unsigned long[Count + 1];
    int *status = new int[Count + 1];
    int *NN = new int[Count + 1];
    int retval = 0;
    int i = 0;
    unsigned long addr = 0;

    for (i = 0; i < Count; i++)
    {
       status[i] = -1;
       NN[i] = node;
       addr = ((unsigned long) ptr) + (i * 4096);
       PTR[i] = (unsigned long) (addr & ~4095UL);
       PTR2[i] = (unsigned long) &PTR[i];
    }

    retval = move_pages(0,       // this thread
                        Count,   // lots of pointers
                        (void **) PTR2,  // The given address
                        NN,      // move to new node please
                        status,  // array of node results
                        MPOL_MF_MOVE);
    if (retval)
    {
       fprintf(stderr, "MoveAddrToNodeMulti to failed\n");
    }
    else
    {
       retval = 0;
       for (i = 0; i < Count; i++)
       {
          if (status[i] != node)
          {
             fprintf(stderr, "Addr 0x%08lx is node %d not %d\n", PTR[i], 
status[i], node);
             retval++;
          }
       }
    }
    delete [] NN;
    delete [] status;
    delete [] PTR2;
    delete [] PTR;
    return retval;
}

int VerifyNumaNode(void *ptr, int node, int Count)
{
    unsigned long *PTR = new unsigned long[Count + 1];
    unsigned long *PTR2 = new unsigned long[Count + 1];
    int *status = new int[Count + 1];
    int retval = 0;
    int i = 0;
    unsigned long addr = 0;

    for (i = 0; i < Count; i++)
    {
       status[i] = -1;
       addr = ((unsigned long) ptr) + (i * 4096);
       PTR[i] = (unsigned long) (addr & ~4095UL);
       PTR2[i] = (unsigned long) &PTR[i];
    }

    retval = move_pages(0,       // this thread
                        Count,   // lots of pointers
                        (void **) PTR2,  // The given address
                        NULL,    // no new node
                        status,  // array of node results
                        MPOL_MF_MOVE);
    if (retval)
    {
       fprintf(stderr, "VerifyNumaNode move_pages failed\n");
    }
    else
    {
       retval = 0;
       for (i = 0; i < Count; i++)
       {
          if (status[i] != node)
          {
             fprintf(stderr, "Verify Addr 0x%08lx is node %d not %d\n", 
PTR[i], status[i], node);
             retval++;
          }
       }
    }

    // release temp stuff

    delete [] status;
    delete [] PTR2;
    delete [] PTR;
    return retval;
}

// small demo program showing:
//
// a: huge page allocations via hugetlb are not node allocated
// b: huge pages cannot be move_page()'ed
// c: Replacing the shm*() with numa_alloc_node() has the exact same problem
// d: 4KB pages or 2MB pages act the same.

int main(int argc, char **argv)
{
    int Node = -1;
    unsigned long Size = 32UL * 1024UL *1024UL;  // default to 32MB

    if (argc >= 2)
    {
       Node = atoi(argv[1]);
    }
    if (argc >= 3)
    {
       Size = atol(argv[2]) * 1024UL * 1024UL;
    }

    unsigned long *Array = (unsigned long *) Allocate(Size, Node);
    exit(-1);
}


